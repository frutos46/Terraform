data "aws_subnet" "AZ_a" {
  availability_zone = "eu-west-1a"
}

data "aws_subnet" "AZ_b" {
  availability_zone = "eu-west-1b"
}

data "aws_vpc" "vpc" {
  default = true ## nos devuelve el id de la vpc por defecto cuando está a true

}