terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.36.0"
    }

  }

}

provider "aws" {
  region = "eu-west-3"

}