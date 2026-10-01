provider "aws" {
  
  region = "ap-south-1"

}
resource "aws_vpc" "raj-vpc" {
   cidr_block = "10.0.0.0/16"
  
}

resource "aws_key_pair" "raj-key" {
    key_name = "terraform-key"
    public_key = file("/home/rajkiran/.ssh/id_rsa.pub")

  
}

resource "aws_subnet" "subnet-01" {
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    vpc_id = aws_vpc.raj-vpc.id
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "raj-igw" {
    vpc_id = aws_vpc.raj-vpc.id
  
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.raj-vpc.id
  
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.raj-igw.id

 }
}
resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.subnet-01.id
    route_table_id = aws_route_table.rt.id
  
}
resource "aws_security_group" "raj-SG1" {
    name = "web"
    vpc_id = aws_vpc.raj-vpc.id
 ingress {
    description = "HTTP from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
 ingress{
    description = "SSH from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }
}
resource "aws_instance" "raj-instance" {
    ami = "ami-01a00762f46d584a1"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.subnet-01.id
    key_name = aws_key_pair.raj-key.key_name
    security_groups = [ aws_security_group.raj-SG1.id ]
  
connection {
  type = "ssh"
  user = "ubuntu"
  private_key = file("/home/rajkiran/.ssh/id_rsa")
  host = self.public_ip
}

provisioner "file" {
    source = "app.py"
    destination = "/home/ubuntu/app.py"
  
}
provisioner "remote-exec" {
    inline = [ "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py &", ]
  
}
}