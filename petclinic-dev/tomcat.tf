resource "aws_security_group" "tomcat" {
  name        = "tomcat"
  description = "Allow tomcat inbound traffic"
  vpc_id      = "vpc-017a2c19d983e3437"


 ingress {
    description      = "SSH from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.alb.id}"]
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.bastion.id}"]
      
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-tomcat-sg"
  }
}


#user_data

data "template_file" "user_data" {
  template = "${file("tomcat_install.sh")}"
}



resource "aws_instance" "tomcat" {
  ami           = "ami-0e6329e222e662a52"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.privatesubnets[0].id
  key_name = aws_key_pair.petclinic.id
  vpc_security_group_ids = ["${aws_security_group.tomcat.id}"]
  user_data = data.template_file.user_data.rendered

  tags = {
    Name = "${var.envname}-tomcat"
  }
}
  

