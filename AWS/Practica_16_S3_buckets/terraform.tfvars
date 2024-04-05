## Asignacion de variables
#enable = true
enable = 1

virginia_cidr = "10.10.0.0/16"
#public_subnet = "10.10.0.0/24"
#private_subnet = "10.10.1.0/24"
subnets = ["10.10.0.0/24", "10.10.1.0/24"]
tags = {
  "env"     = "Dev"
  "project" = "cerberus"
  "region"  = "virginia"
}
sg_ingress_address = "0.0.0.0/0"
