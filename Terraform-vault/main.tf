provider "aws" {
    region = "ap-south-1"
  
}

provider "vault" {
  address = "http://43.204.32.26:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "3f95f805-590c-f8a4-3bb7-5d5e65ae8a47"
      secret_id = "d8ed2638-3abe-3f5b-bfa5-bb2d78322a93"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "secret-kv" // change it according to your mount
  name  = "test-secret" // change it according to your secret
}


resource "aws_instance" "my_instance" {
  ami           = "ami-01a00762f46d584a1"
  instance_type = "t2.micro"
  subnet_id = "subnet-0a4f46ed5e840eac2"

  tags = {
  
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}