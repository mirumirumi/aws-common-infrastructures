resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.resource_prefix}-${var.env_name}-tfstate-artifactstore"

  tags = var.tags
}

resource "aws_s3_bucket_acl" "tfstate" {
  bucket = "${var.resource_prefix}-${var.env_name}-tfstate-artifactstore"
  acl    = "private"
}

resource "aws_s3_bucket" "sam-artifactstore" {
  bucket = "${var.resource_prefix}-${var.env_name}-sam-artifactstore"

  tags = var.tags
}

resource "aws_s3_bucket_acl" "sam-artifactstore" {
  bucket = "${var.resource_prefix}-${var.env_name}-sam-artifactstore"
  acl    = "private"
}
