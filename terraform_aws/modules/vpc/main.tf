## vpc ##
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

## subnets ##
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr1
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zones1

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "db_private_subnets" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr2
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zones2

  tags = {
    Name = "db-private-subnet"
  }
}

## igw ##
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my_igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "Nat_gateway_eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "Nat_gateway"
  }
}

## route tables ##
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  # ADDED: NAT Gateway route for outbound internet access in private subnets
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnets.id
  route_table_id = aws_route_table.private_rt.id
}

## db rt ##
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.db_private_subnets.id
  route_table_id = aws_route_table.private_rt.id
}