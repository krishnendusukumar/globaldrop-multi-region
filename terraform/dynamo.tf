resource "aws_dynamodb_table" "globaldrop_results" {
    name = "globaldrop-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "fileId"
    attribute {
        name = "fileId"
        type = "S"
    }
    stream_enabled   = true
    stream_view_type = "NEW_AND_OLD_IMAGES"
    replica {
        region_name = "eu-west-1"
    }
    tags = {
        Project = "GlobalDrop"
    }
}