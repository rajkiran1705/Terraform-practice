terraform {
  backend "s3" {
    bucket = "raj-s6-bucket"
    key = "raj/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    dynamodb_table = "terraform-lock"
    
  }
}