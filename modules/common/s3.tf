resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.resource_prefix}-${var.env_name}-tfstate-artifactstore"
  acl    = "private"

  tags = var.tags
}

resource "aws_s3_bucket" "sam-artifactstore" {
  bucket = "${var.resource_prefix}-${var.env_name}-sam-artifactstore"
  acl    = "private"

  tags = var.tags
}
