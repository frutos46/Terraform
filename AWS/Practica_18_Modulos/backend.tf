/*terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region  = "us-east-1"
    bucket  = "example-us-east-1-prod-frutos-terraform-state"
    key     = "terraform.tfstate"
    profile = ""
    encrypt = "true"

    dynamodb_table = "example-us-east-1-prod-frutos-terraform-state-lock"
  }
}
*/