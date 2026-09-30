provider "aws" {

region = "ap-south-1"
  
}

resource "aws_instance" "raj" {

    ami = "ami-01a00762f46d584a1"
    instance_type = "t3.micro"
    subnet_id = "subnet-0a4f46ed5e840eac2"
    key_name = "ansible"
    security_groups = ["sg-08f3973a922eb269a"]
}

resource "aws_s3_bucket" "s3_bucket" {

    bucket = "raj-s6-bucket"
  
}
resource "aws_dynamodb_table" "terraform-lock" {
   name = "terraform-lock"
   billing_mode = "PAY_PER_REQUEST"
   hash_key = "LockID"

   attribute {
     name = "LockID"
     type = "S"
   }
  
}
