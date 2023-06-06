terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
#      version = "~> 3.27"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}