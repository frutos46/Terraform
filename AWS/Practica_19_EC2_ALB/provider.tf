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
  region = "eu-west-1"

}