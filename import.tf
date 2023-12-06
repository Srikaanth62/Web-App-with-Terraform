# main.tf

provider "aws" {
  region = "us-east-1"
  # Add other AWS provider configurations if needed
}

resource "aws_vpc" "wordpress-vpc" {
  cidr_block = "10.0.0.0/16"  # Replace with your desired CIDR block
  # Add other configuration options as needed
}

