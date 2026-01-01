# VERSIONING - PRIMARY
resource "aws_s3_bucket_versioning" "primary" {
  bucket = aws_s3_bucket.primary_region.id
  versioning_configuration {
    status = "Enabled"
  }
}

# VERSIONING - SECONDARY (EU provider use karna zaroori)
resource "aws_s3_bucket_versioning" "secondary" {
  provider = aws.eu
  bucket   = aws_s3_bucket.secondary_region.id
  versioning_configuration {
    status = "Enabled"
  }
  depends_on = [aws_s3_bucket.secondary_region]
}

# REPLICATION ROLE
resource "aws_iam_role" "replication" {
  name = "globaldrop_s3_replication_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "s3.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "replication" {
  name = "globaldrop_s3_replication_policy"
  role = aws_iam_role.replication.id # ← YEH SAHI HAI (.arn galat tha)

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Resource = "${aws_s3_bucket.primary_region.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = "s3:ReplicateObject"
        Resource = "${aws_s3_bucket.secondary_region.arn}/*"
      }
    ]
  })
}

# PRIMARY → SECONDARY REPLICATION - FIX: depends_on + filter correct
resource "aws_s3_bucket_replication_configuration" "primary_to_secondary" {
  bucket = aws_s3_bucket.primary_region.id
  role   = aws_iam_role.replication.arn

  rule {
    id     = "replicate-all"
    status = "Enabled"

    destination {
      bucket = aws_s3_bucket.secondary_region.arn
    }

    filter {} # ← empty filter = all objects
    delete_marker_replication {
  status = "Enabled"
}
  }

  depends_on = [aws_s3_bucket_versioning.primary, aws_s3_bucket_versioning.secondary]
}