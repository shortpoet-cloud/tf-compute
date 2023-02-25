terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.13"
}

# Configure the AWS Provider
provider "aws" {
  assume_role {
    role_arn = ""
  }
}
