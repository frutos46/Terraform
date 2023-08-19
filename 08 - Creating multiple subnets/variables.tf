variable "number_of_subnets" {
  type        = number
  description = "Definimos numero de subnets"
  default     = 2
  validation {
    condition     = var.number_of_subnets < 5 ## condition 
    error_message = "The numbers of subnets must be less than 5"
  }
}