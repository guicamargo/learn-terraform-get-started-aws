terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-061fe7df6ad657197"
  instance_type = "t2.micro"
  key_name      = "learn-terraform"

  tags = {
    Name = "terraform-ansible-python"
  }
}