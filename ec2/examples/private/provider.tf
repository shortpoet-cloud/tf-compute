terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.13"
}

# Configure the AWS Provider
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::341864192726:role/iam-role-admin-us-east-1"
  }
}
