resource "aws_security_group" "acesso-geral" {
  name        = "acesso-geral"
  description = "Security group for general access"


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "acesso_geral"
  }
  
}