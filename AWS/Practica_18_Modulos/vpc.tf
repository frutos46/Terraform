
resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    Name = "VPC Virgina-${local.sufix}"

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

## Invocamos modulo

/*module "mybucket" {
  source        = "./Modulos/S3"
  bucket_name12 = "NombreUnico123456"
}

output "s3_arn" {
  value = module.mybucket.s3_bucket_arn

}*/

# You cannot create a new backend by simply defining this and then
# immediately proceeding to "terraform apply". The S3 backend must
# be bootstrapped according to the simple yet essential procedure in
# https://github.com/cloudposse/terraform-aws-tfstate-backend#usage
module "terraform_state_backend" {
  source = "cloudposse/tfstate-backend/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "1.4.1"
  version    = "1.4.1"
  namespace  = "example"
  stage      = "prod-frutos"
  name       = "terraform"
  environment = "us-east-1"
  attributes = ["state"]

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false
}

# Your Terraform configuration
