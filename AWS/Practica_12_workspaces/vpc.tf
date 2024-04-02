
resource "aws_vpc" "vpc_virginia" {
  #cidr_block = var.virginia_cidr
  cidr_block = lookup(var.virginia_cidr, terraform.workspace) ## previamente hemos definido el workspace con terraform workspace new <name workspace>
  tags = {
    Name = "VPC Virgina"

  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_virginia.id
  cidr_block              = var.subnets[0]
  map_public_ip_on_launch = true ## si esta true se indica que se asignen ips publicas a las ec2
  tags = {
    Name = "Public subnet"

  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_virginia.id
  cidr_block = var.subnets[1]
  tags = {
    Name = "Private Subnet"

  }

  depends_on = [aws_subnet.public_subnet] ## la creacion de la private subnet depende de que se cree la public 
}

##para poder conectarnos desde fuera a la vpc

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_virginia.id

  tags = {
    Name = "igw vpc virginia"
  }

  depends_on = [aws_vpc.vpc_virginia]
}

## tabla de enrutamiento
resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.vpc_virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public CRT"
  }
}

## asociamos la tabla de enrutamiento con la subnet public
resource "aws_route_table_association" "crta_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}

resource "aws_security_group" "sg_public_instance" {
  name        = "Public Instance Security Group"
  description = "Allow SSH inbound traffic and all egress traffic"
  vpc_id      = aws_vpc.vpc_virginia.id

  ingress {
    description = "Allow SSH over Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = [var.sg_ingress_address]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "Public Instance Security Group"
  }

}