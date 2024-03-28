resource "aws_vpc" "vpc_virginia" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "VPC Virgina"
    env= "dev"
  }
}

resource "aws_vpc" "vpc_Ohio" {
  cidr_block = "10.2.0.0/16"
  tags = {
    Name = "VPC Ohio"
    env= "dev"
  }
  provider = aws.Ohio
}