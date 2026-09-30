provider "aws" {
    region = "ap-south-1"
  
}
  

variable "ami_value" {

    description = "value"
  
}

variable "subnet" {

    description = "value"
  
}

variable "instance_type" {
    description = "value"
    type = map(string)
    default = {
      "dev" = "t2.micro"
      "stag" = "t2.medium"
      "prod" = "t2.xlarge"
       
    }
}
module "ec2_instance" {
    source = "./modules/ec2-instance"
    ami_value = var.ami_value
    subnet = var.subnet
    instance_type = lookup(var.instance_type,terraform.workspace,"t2.micro")
  
}
  
