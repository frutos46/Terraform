## Definicion de variables

variable "virginia_cidr" {
  description = "CIDR de Virginia"
  type        = string
  sensitive   = false #si esta en false se muestra el cidr en el terraform plan, en true no
}

/*
variable "public_subnet" {
  description = "CIDR public subnet"
  type        = string
  sensitive   = false #si esta en false se muestra el cidr en el terraform plan, en true no
}

variable "private_subnet" {
  description = "CIDR private subnet"
  type        = string
  sensitive   = false #si esta en false se muestra el cidr en el terraform plan, en true no
} 
*/

variable "subnets" {
  description = "Lista de subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags del proyecto"
  type        = map(string)
}

variable "sg_ingress_address" {
  description = "CIDR for ingress traffic"
  type        = string
}

