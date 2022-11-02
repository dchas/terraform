resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-017a2c19d983e3437"

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-alb-sg"
  }
}
