terraform {
  backend "s3" {
    bucket         = "terraformbackendcicd"
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locked"
    encrypt        = true
  }
}