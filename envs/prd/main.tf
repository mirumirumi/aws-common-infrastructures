provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket = "common-prd-tfstate-artifactstore"
    region = "ap-northeast-1"
    key    = "terraform.tfstate"
  }
}

locals {
  resource_prefix = "common"
  env_name        = "prd"
}

locals {
  tags = {
    project = "common"
    env     = local.env_name
    IaC     = "tf"
  }
}

module "modules" {
  source   = "../../modules"

  resource_prefix = local.resource_prefix
  env_name        = local.env_name
  tags            = local.tags
}
