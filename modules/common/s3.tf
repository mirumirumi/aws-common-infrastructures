# Terraform states

resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.resource_prefix}-${var.env_name}-tfstate-artifactstore"
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "tfstate" {
  bucket = "${var.resource_prefix}-${var.env_name}-tfstate-artifactstore"
  acl    = "private"
}

# SAM artifacts

resource "aws_s3_bucket" "sam_artifactstore" {
  bucket = "${var.resource_prefix}-${var.env_name}-sam-artifactstore"
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "sam_artifactstore" {
  bucket = "${var.resource_prefix}-${var.env_name}-sam-artifactstore"
  acl    = "private"
}

# mirumi.me

resource "aws_s3_bucket" "mirumi_me" {
  bucket = "mirumime-${var.env_name}-mirumi-me"
  tags   = var.tags
}

# いつからかエラーが出るようになったらしく、Terraform で管理しないようがいい雰囲気があるっぽいので外した（No changes）
# https://zenn.dev/dyokoo3/scraps/ed9c3ef9b425b2
# resource "aws_s3_bucket_acl" "mirumi_me" {
#   bucket = "mirumime-${var.env_name}-mirumi-me"
#   acl    = "private"
# }

resource "aws_s3_bucket_public_access_block" "mirumi_me" {
  bucket = "mirumime-${var.env_name}-mirumi-me"

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "mirumi_me" {
  bucket = "mirumime-${var.env_name}-mirumi-me"

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "mirumi_me" {
  bucket = "mirumime-${var.env_name}-mirumi-me"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MirumiMeOriginCustomHeader",
  "Statement": [
    {
      "Sid": "MirumiMeOriginCustomHeader",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.mirumi_me.id}/*",
      "Condition": {
        "StringLike": {
          "aws:Referer": [
            "${aws_s3_bucket.mirumi_me.bucket_domain_name}"
          ]
        }
      }
    }
  ]
}
POLICY
}

# mirumi.media

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

resource "aws_s3_bucket_policy" "mirumi_media" {
  count  = var.env_name == "prd" ? 1 : 0
  bucket = "mirumime-${var.env_name}-mirumi-media"
  policy = <<POLICY
{
  "Id": "OAIBucketPolicy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "OAIBucketPolicy",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.mirumi_media[count.index].id}"
      },
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.mirumi_media[count.index].arn}/*"
    }
  ]
}
POLICY
}
