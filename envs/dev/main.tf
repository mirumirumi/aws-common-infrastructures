provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket = "common-dev-tfstate-artifactstore"
    region = "ap-northeast-1"
    key    = "terraform.tfstate"
  }
}

locals {
  resource_prefix = "common"
  env_name        = "dev"
  tags = {
    project = "common"
    env     = local.env_name
    IaC     = "tf"
  }
}

module "modules" {
  source   = "../../modules/common"

  resource_prefix = local.resource_prefix
  env_name        = local.env_name
  tags            = local.tags
}

module "virginia" {
  source   = "../../modules/virginia"

  resource_prefix = local.resource_prefix
  env_name        = local.env_name
  tags            = local.tags
}
