terraform {
  backend "s3" {
    bucket         = "globaldrop-terraform-state"
    key            = "global/state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}