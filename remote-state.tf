/*
resource "aws_s3_bucket" "terraform_state" {
  bucket = "ziad-terraform-state-file"
    lifecycle {
      prevent_destroy = true
    }
    #region = "us-east-2"

}
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_dynamodb_table" "terraform_locks" {
  name = "ziad-terraform-tfstate"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "ID"
  attribute {
    name = "ID"
    type = "S"
  }
}
*/
terraform {
  backend "s3" {
    bucket = "ziad-terraform-state-file"
    key = "dev/terraform.tfstate"  
    region = "us-east-2"

    dynamodb_table = "ziad-terraform-tfstate"
    encrypt        = true
      }
}
