resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "aws_s3_bucket" "primary_region" {
  bucket = "${var.project_name}.upload.primary.${random_string.suffix.result}"
}

resource "aws_s3_bucket" "secondary_region" {
  provider = aws.eu
  bucket   = "${var.project_name}.upload.1.1.secondary.upload.${random_string.suffix.result}"
}