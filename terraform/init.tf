provider "aws" {
  # default provider
  region = "us-west-1"

}

provider "aws" {
  alias  = "smce-west1"
  region = "us-west-1"
  access_key = var.smce_aws_access_key
  secret_key = var.smce_aws_secret_key
  token      = var.smce_aws_session_token
}

terraform {
  required_version = "1.3.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket         = "veda-jh-environment-tf-state-bucketv2"
    key            = "root"
    region         = "us-west-2"
  }
}

