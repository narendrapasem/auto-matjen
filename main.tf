terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.28.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
  //access_key = "AKIAQKHHME6VY7BG4RWN"
  //secret_key = "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"
}