terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-curation-library-mapper"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}