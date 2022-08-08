variable "product" {
  type    = string
  default = "fresh-video"
}

variable "application" {
  type    = string
  default = "infra"
}

variable "cidr" {
  type    = string
  default = "10.100.99.0/24"
}

variable "availability_zone" {
  type        = list(string)
  default     = [ "us-east-1a", "us-east-1e", "us-east-1f" ]
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {

  workspace = terraform.workspace == "default" ? "master" : terraform.workspace

}