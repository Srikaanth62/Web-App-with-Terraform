#provider "aws" {
#  region = "us-east-1" # Change this to your desired region
#}

# Create VPC
resource "aws_vpc" "srikaanth_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "srikaanth_vpc"
  }
}

# Create Subnets
resource "aws_subnet" "subnet_public1_us_east_1a" {
  vpc_id                  = aws_vpc.srikaanth_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "project-subnet-public1-us-east-1a"
  }
}

resource "aws_subnet" "subnet_private1_us_east_1a" {
  vpc_id                  = aws_vpc.srikaanth_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "project-subnet-private1-us-east-1a"
  }
}

resource "aws_subnet" "subnet_public2_us_east_1b" {
  vpc_id                  = aws_vpc.srikaanth_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "project-subnet-public2-us-east-1b"
  }
}

resource "aws_subnet" "subnet_private2_us_east_1b" {
  vpc_id                  = aws_vpc.srikaanth_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "project-subnet-private2-us-east-1b"
  }
}

# Create Route Tables
resource "aws_route_table" "rtb_public" {
  vpc_id                  = aws_vpc.srikaanth_vpc.id
  tags = {
    Name = "project-rtb-public"
  }
}

resource "aws_route_table" "rtb_private1_us_east_1a" {
  vpc_id                  = aws_vpc.srikaanth_vpc.id
  tags = {
    Name = "project-rtb-private1-us-east-1a"
  }
}

resource "aws_route_table" "rtb_private2_us_east_1b" {
  vpc_id                  = aws_vpc.srikaanth_vpc.id
  tags = {
    Name = "project-rtb-private2-us-east-1b"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.srikaanth_vpc.id
  tags = {
    Name = "project-igw"
  }
}

# Create NAT Gateways
resource "aws_nat_gateway" "nat_public1_us_east_1a" {
  allocation_id = aws_eip.nat_eip_public1_us_east_1a.id
  subnet_id     = aws_subnet.subnet_public1_us_east_1a.id
  tags = {
    Name = "project-nat-public1-us-east-1a"
  }
}

resource "aws_nat_gateway" "nat_public2_us_east_1b" {
  allocation_id = aws_eip.nat_eip_public2_us_east_1b.id
  subnet_id     = aws_subnet.subnet_public2_us_east_1b.id
  tags = {
    Name = "project-nat-public2-us-east-1b"
  }
}

# Create Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eip_public1_us_east_1a" {
  vpc = true
}

resource "aws_eip" "nat_eip_public2_us_east_1b" {
  vpc = true
}

# Associate Route Tables with Subnets
resource "aws_route_table_association" "association_public1_us_east_1a" {
  subnet_id      = aws_subnet.subnet_public1_us_east_1a.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table_association" "association_private1_us_east_1a" {
  subnet_id      = aws_subnet.subnet_private1_us_east_1a.id
  route_table_id = aws_route_table.rtb_private1_us_east_1a.id
}

resource "aws_route_table_association" "association_public2_us_east_1b" {
  subnet_id      = aws_subnet.subnet_public2_us_east_1b.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table_association" "association_private2_us_east_1b" {
  subnet_id      = aws_subnet.subnet_private2_us_east_1b.id
  route_table_id = aws_route_table.rtb_private2_us_east_1b.id
}
