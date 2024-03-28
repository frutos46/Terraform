terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.43.0"
    }
  }
  required_version = "1.7.5"
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.tags ## se van a aplicar todas las tags comunes a todo lo que se despligue bajo ese provider
  }
}

