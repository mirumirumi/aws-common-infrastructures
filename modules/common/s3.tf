resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.resource_prefix}-${var.env_name}-tfstate-artifactstore"
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "tfstate" {
  bucket = "${var.resource_prefix}-${var.env_name}-tfstate-artifactstore"
  acl    = "private"
}



resource "aws_s3_bucket" "sam_artifactstore" {
  bucket = "${var.resource_prefix}-${var.env_name}-sam-artifactstore"
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "sam_artifactstore" {
  bucket = "${var.resource_prefix}-${var.env_name}-sam-artifactstore"
  acl    = "private"
}



# resource "aws_s3_bucket" "mirumi_me" {
#   count  = var.env_name == "prd" ? 1 : 0
#   bucket = "mirumime-${var.env_name}-mirumi-me"
#   tags   = var.tags
# }

# resource "aws_s3_bucket_acl" "mirumi_me" {
#   count  = var.env_name == "prd" ? 1 : 0
#   bucket = "mirumime-${var.env_name}-mirumi-me"
#   acl    = "private"
# }

# resource "aws_s3_bucket_public_access_block" "mirumi_me" {
#   count  = var.env_name == "prd" ? 1 : 0
#   bucket = "mirumime-${var.env_name}-mirumi-me"

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_website_configuration" "mirumi_me" {
#   count  = var.env_name == "prd" ? 1 : 0
#   bucket = "mirumime-${var.env_name}-mirumi-me"

#   index_document {
#     suffix = "index.html"
#   }
# }

# resource "aws_s3_bucket_policy" "mirumi_me" {
#   count  = var.env_name == "prd" ? 1 : 0
#   bucket = "mirumime-${var.env_name}-mirumi-me"
#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Id": "MirumiMeOriginCustomHeader",
#   "Statement": [
#     {
#       "Sid": "MirumiMeOriginCustomHeader",
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": "s3:GetObject",
#       "Resource": "arn:aws:s3:::${aws_s3_bucket.mirumi_me.id}/*",
#       "Condition": {
#         "StringLike": {
#           "aws:Referer": [
#             "${aws_s3_bucket.mirumi_me.bucket_domain_name}"
#           ]
#         }
#       }
#     }
#   ]
# }
# POLICY
# }



resource "aws_s3_bucket" "mirumi_media" {
  count  = var.env_name == "prd" ? 1 : 0
  bucket = "mirumime-${var.env_name}-mirumi-media"
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "mirumi_media" {
  count  = var.env_name == "prd" ? 1 : 0
  bucket = "mirumime-${var.env_name}-mirumi-media"
  acl    = "private"
}
