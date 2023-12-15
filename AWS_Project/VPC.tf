# Provider configuration for AWS
#provider "aws" {
#  region = "us-east-1" # Change to your desired region
#}

# VPC creation
resource "aws_vpc" "project_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Subnets creation
resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = "us-east-1b"
}

# Internet Gateway
resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.project_vpc.id
}

# Route Tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_igw.id
  }
}

# NAT Gateways
resource "aws_nat_gateway" "nat_gateway_1a" {
  allocation_id = aws_eip.nat_eip_1a.id
  subnet_id     = aws_subnet.public_subnet_1a.id
}

resource "aws_eip" "nat_eip_1a" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway_1b" {
  allocation_id = aws_eip.nat_eip_1b.id
  subnet_id     = aws_subnet.public_subnet_1b.id
}

resource "aws_eip" "nat_eip_1b" {
  vpc = true
}

# Route Tables for private subnets
resource "aws_route_table" "private_route_table_1a" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_1a.id
  }
}

resource "aws_route_table" "private_route_table_1b" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_1b.id
  }
}
