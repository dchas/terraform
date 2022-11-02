resource "aws_security_group" "bastion" {
  name        = "bastion"
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
    Name = "${var.envname}-bastion-sg"
  }
}

#key
resource "aws_key_pair" "petclinic" {
  key_name   = "petclinic-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+eU4uOW+pbJmgoVCYsxc/CjA/JpPt3PXv/+tBgcjfZWec9d1TERYkiQ9mlfrad7QhOTAAhZ4Viw07XiGNXRL5B2qqXsWjD7ZW06syK/yoPu+WTtzS7FHjgQz7hBlaEDz4l3jyPWZd6xwiiKTmvvrtTEmWERWIvlxTMy+1vjW2P+sEUycFiug+W8dYjmaNP/JrrE/8Ih8QGbFFlRzto7CDpBOrVM8+ZRHFoeRB6ZIMaeqRO9wGwMK17GA86MtWT4Ot+892LIGRTCREWZ5EatkUuAf7sxqnGy9lw6YaQLC2dzQ/vFiadevK3GPEv1ME+fRWHndkIC0FrAkiJ4Jc3A1ey4PzmDhFCvY+faZCVN+HJt5hQzEN3FSohEZriuLsy1lDzywDE3pVobipUm7+a0RhRhOy7UvVxSRYWHooZl5QOYNb8YeDBi+04af53POdwyhkMqRk6CA0CGIDpexX4lnReh8c6OblEqibRQuVRXeaDGRKk0gemcxaSU/plZyBce8= chandrahas@DESKTOP-TUHTTI4"
 }


#ec2

resource "aws_instance" "bastion" {
  ami           = "ami-0e6329e222e662a52"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.pubsubnets[0].id
  key_name = aws_key_pair.petclinic.id
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  tags = {
    Name = "${var.envname}-bastion"
  }
}
