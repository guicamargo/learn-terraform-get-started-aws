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
resource "aws_launch_template" "maquina" {
  image_id           = "ami-061fe7df6ad657197"
  instance_type = var.instance
  key_name      = var.key
   vpc_security_group_ids = [aws_security_group.acesso-geral.id]

  tags = {
    Name = "terraform-ansible-python"
  }
  user_data = filebase64("ansible.sh")
depends_on = [aws_key_pair.chaveSSH]
}

resource "aws_autoscaling_group" "grupo" {
  availability_zones = [ "${var.region_aws}a", "${var.region_aws}b"]
  name = var.nomeGrupo
  max_size = var.maximo
  min_size = var.minimo
  launch_template {
    id = aws_launch_template.maquina.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.alvoLoadBalancer.arn]
}
resource "aws_default_subnet" "subnet-1" {
  availability_zone = "${var.region_aws}a"
}
resource "aws_default_subnet" "subnet-2" {
  availability_zone = "${var.region_aws}b"
}

resource "aws_lb" "loadBalancer" {
  internal = false
  subnets= [ aws_default_subnet.subnet-1.id, aws_default_subnet.subnet-2.id]

}

resource "aws_default_vpc" "default" {
  
}
resource "aws_lb_target_group" "alvoLoadBalancer" {
  name = "maquinaAlvo"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default.id
  
}

resource "aws_lb_listener" "entradaLoadBalancer" {
  load_balancer_arn = aws_lb.loadBalancer.arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alvoLoadBalancer.arn
  }
}