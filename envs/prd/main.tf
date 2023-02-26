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

  acm_arn_mirumi_me    = module.virginia.acm_arn_mirumi_me
  acm_arn_mirumi_media = module.virginia.acm_arn_mirumi_media
}

module "virginia" {
  source   = "../../modules/virginia"

  resource_prefix = local.resource_prefix
  env_name        = local.env_name
  tags            = local.tags

  cloudfront_domain_name_mirumi_me    = module.modules.cloudfront_domain_name_mirumi_me
  cloudfront_domain_name_mirumi_media = module.modules.cloudfront_domain_name_mirumi_media
}
