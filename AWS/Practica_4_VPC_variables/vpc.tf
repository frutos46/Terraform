resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    Name = "VPC Virgina"
    env= "dev"
  }
}

resource "aws_vpc" "vpc_Ohio" {
  cidr_block = var.ohio_cidr
  tags = {
    Name = "VPC Ohio"
    env= "dev"
  }
  provider = aws.Ohio
}

