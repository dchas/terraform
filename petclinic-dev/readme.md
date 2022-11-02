1--> install the terraform and setup the path
2--> install the aws-cli and configure the keys
profile for the aws-cli : your usr home directory --> .aws/
config/credentials


argument : (input)
attributes : (output)


terraform.exe plan --var-file devops.tfvars
Q.what is tfstate ?
A--> store created resource information


1)..create the scenario for the forces replacement----can see kyeword----forces replacement



we are going to create vpc by using terraform
provider : aws
region : ap-south-1
resource : vpc
cidr : 10.1.0.0/16
enable dns host = true

creating subents by using terraform
publicsubnet : ["10.1.0.0/24","10.1.1.0/24,"10.1.2.0/24"]
privatesubnet : ["10.1.3.0/24","10.1.4.0/24,"10.1.5.0/24"]
datasubnet : ["10.1.6.0/24","10.1.7.0/24,"10.1.8.0/24"]

igw =
attach =
eip =
nat-gw =

route tables
pubroute =
private route =


associate the publicsubnets with the igw
associate the peivatesubnets with the nat-gw

terraform init
terraform validate 
terraform plan 
terraform apply

tomcat-sg
resource "aws_security_group" "tomcat" {
  name        = "tomcat"
  description = "Allow tomcat inbound traffic"
  vpc_id      = "vpc-017a2c19d983e3437"

  ingress {
    description      = "SSH from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups  = ["aws_security_group.alb.id"]
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = ["aws_security_group.bastion-sg.id"]
      
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


rds-sg
resource "aws_security_group" "rds" {
  name        = "rds"
  description = "Allow rds inbound traffic"
  vpc_id      = "vpc-017a2c19d983e3437"

  ingress {
    description      = "rds from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["aws_security_group.tomcat.id"]
  }

  ingress {
    description      = "rds from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["aws_security_group.bastion-sg.id"]
       
  }  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-rds-sg"
  }
}

alb-sg
resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Allow alb inbound traffic"
  vpc_id      = "vpc-017a2c19d983e3437"

  ingress {
    description      = "alb  from VPC"
    from_port        = 80
    to_port          = 80
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

