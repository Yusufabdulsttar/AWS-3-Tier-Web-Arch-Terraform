// Create a VPC with the specified CIDR block
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block_vpc

  tags = {
    Name = "VPC-WebApp"
  }
}

// Create a public subnet for web tier within the VPC in two AZ
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_block_public_subnet_1
  availability_zone = var.availability_zone_1
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_subnet_Web_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_block_public_subnet_2
  availability_zone = var.availability_zone_2
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_subnet_Web_2"
  }
}

// Create a private subnet for app tier within the VPC in two AZ
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_block_private_subnet_1
  availability_zone = var.availability_zone_1

  tags = {
    Name = "Private_subnet_app_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_block_private_subnet_2
  availability_zone = var.availability_zone_2

  tags = {
    Name = "Private_subnet_app_2"
  }
}

// Create a private subnet for DB tier within the VPC in two AZ
resource "aws_subnet" "private_subnet_db_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_block_private_subnet_db_1
  availability_zone = var.availability_zone_1

  tags = {
    Name = "private_subnet_db_1"
  }
}

resource "aws_subnet" "private_subnet_db_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_block_private_subnet_db_2
  availability_zone = var.availability_zone_2

  tags = {
    Name = "private_subnet_db_2"
  }
}

// Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    Name = "VPC-WebApp-Gateway"
  }
}

// Create a public route table for Public Subnets
resource "aws_route_table" "public_subnet_1_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_subnet_1_route_table"
  }
}

resource "aws_route_table" "public_subnet_2_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_subnet_2_route_table"
  }
}

// Associate the public route table with the Public subnets
resource "aws_route_table_association" "Public_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_subnet_1_route_table.id
}

resource "aws_route_table_association" "Public_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_subnet_2_route_table.id
}

// Elastic Ip for NAT Gateway
resource "aws_eip" "e_ip" {
  domain = "vpc"
  tags = {
    Name = "iP for NAT"
  }
}

// NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id     = aws_eip.e_ip.id
  subnet_id         = aws_subnet.public_subnet_1.id

  tags = {
    Name = "Nat for App"
  }
}

//Route table for App Subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Route table for App Subnets"
  }
}

resource "aws_route_table_association" "private_asscociation_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_asscociation_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}