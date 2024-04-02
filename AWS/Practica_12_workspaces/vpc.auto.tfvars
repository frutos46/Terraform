## Asignacion de variables

#virginia_cidr = "10.10.0.0/16"
virginia_cidr = {
  "prod" = "10.10.0.0/16"
  "dev" = "172.16.0.0/16"
}
#public_subnet = "10.10.0.0/24"
#private_subnet = "10.10.1.0/24"
subnets = ["10.10.0.0/24", "10.10.1.0/24"]
tags = {
  "env" = "Dev"
}

sg_ingress_address = "0.0.0.0/0"