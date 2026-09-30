provider "aws" {

    region = "ap-south-1"
    
  
}

variable "ami_value" {
    description = "value"
  
}

variable "instance_type" {
    description = "value"
  
}

variable "subnet" {

    description = "value"
  
}

resource "aws_instance" "example" {

ami = var.ami_value
instance_type = var.instance_type
subnet_id = var.subnet
associate_public_ip_address = true
key_name = "ansible"
vpc_security_group_ids = ["sg-08f3973a922eb269a"]
  
}