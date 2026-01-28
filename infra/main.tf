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
  region = var.region_aws
}

resource "aws_key_pair" "chaveSSH" {
  key_name   = var.key
  public_key = file("${path.root}/${var.key}.pub")
}

resource "aws_instance" "app_server" {
  ami           = "ami-061fe7df6ad657197"
  instance_type = var.instance
  key_name      = var.key
  vpc_security_group_ids = [aws_security_group.acesso-geral.id]

  tags = {
    Name = "terraform-ansible-python"
  }
depends_on = [aws_key_pair.chaveSSH, aws_security_group.acesso-geral]
}

output "IP_publico" {
  value = aws_instance.app_server.public_ip
}