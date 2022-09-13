terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.28.0"
    }
  }
}

provider "aws" {
   region = var.aws_region
   shared_credentials_file = "/Users/samueldare/.aws/credentials"
   profile = "Narendra"
}