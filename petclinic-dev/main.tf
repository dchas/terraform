resource "aws_vpc" "petclinic" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.envname}-vpc"
  }
}


#subnets 

resource "aws_subnet" "pubsubnets" {
  count = length(var.az)
  vpc_id     = "vpc-017a2c19d983e3437"
  cidr_block = element(var.pubsubnets,count.index)
  availability_zone = element(var.az,count.index)
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.envname}-pubsubnets-${count.index+1}"
  }
}

resource "aws_subnet" "privatesubnets" {
  count = length(var.az)
  vpc_id     = "vpc-017a2c19d983e3437"
  cidr_block = element(var.privatesubnets,count.index)
  availability_zone = element(var.az,count.index)

  tags = {
    Name = "${var.envname}-privatesubnets-${count.index+1}"
  }
}

resource "aws_subnet" "datasubnets" {
  count = length(var.az)
  vpc_id     = "vpc-017a2c19d983e3437"
  cidr_block = element(var.datasubnets,count.index)
  availability_zone = element(var.az,count.index)

  tags = {
    Name = "${var.envname}-datasubnets-${count.index+1}"
  }
}

#igw
#attach to the vpc

resource "aws_internet_gateway" "gw" {
  vpc_id = "vpc-017a2c19d983e3437"

  tags = {
    Name = "${var.envname}-igw"
  }
}

#eip
resource "aws_eip" "nat-ip" {
  vpc      = true
    tags = {
    Name = "${var.envname}-nat-ip"
  }
}

#nat-gw
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-ip.id
  subnet_id     = aws_subnet.pubsubnets[0].id

  tags = {
    Name = "${var.envname}-nat-gw"
  }
} 

#route tables
resource "aws_route_table" "public-route" {
  vpc_id = "vpc-017a2c19d983e3437"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
 tags = {
    Name = "${var.envname}-public-route"
  }
}

resource "aws_route_table" "private-route" {
  vpc_id = "vpc-017a2c19d983e3437"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
 tags = {
    Name = "${var.envname}-private-route"
  }
}

resource "aws_route_table" "data-route" {
  vpc_id = "vpc-017a2c19d983e3437"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
 tags = {
    Name = "${var.envname}-data-route"
  }
}
#assocoate
resource "aws_route_table_association" "pubsub-association" {
  count = length(var.pubsubnets)
  subnet_id      = element(aws_subnet.pubsubnets.*.id,count.index)
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "private-association" {
  count = length(var.privatesubnets)
  subnet_id      = element(aws_subnet.privatesubnets.*.id,count.index)
  route_table_id = aws_route_table.private-route.id
}

resource "aws_route_table_association" "datasub-association" {
  count = length(var.datasubnets)
  subnet_id      = element(aws_subnet.datasubnets.*.id,count.index)
  route_table_id = aws_route_table.data-route.id
}
