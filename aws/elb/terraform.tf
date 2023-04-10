provider "aws" {
    region = local.region
  
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "infra" {
  backend   = "s3"
  config = {
    region  = local.region
    bucket  = local.remote_state_bucket
    key     = local.remote_state_key_infra
}
}
