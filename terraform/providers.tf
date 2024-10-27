
terraform {
  required_providers {
    aws = {
      version = "~> 5.69.0"
    }
  }
  required_version = "~> 1.9.7"
}

provider "aws" {
  profile = "default"
  region  = var.region
}


