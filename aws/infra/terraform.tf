provider "aws" {
    region = local.region
}
terraform {
  backend "s3" {}
}
