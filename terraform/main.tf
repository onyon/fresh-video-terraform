provider "aws" {
  default_tags {
    tags = {
      Product      = var.product
      Application  = "terraform"
      Workspace    = local.workspace
    }
  }
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    atlas = {
      source  = "ariga/atlas"
      version = "~> 0.1.0"
    }
  }
  backend "s3" {
    key                  = "base.json"
    region               = "us-east-1"
    bucket               = "fresh-video-terraform"
    workspace_key_prefix = "infrastructure"
    dynamodb_table       = "fresh-video-terraform"
  }
}