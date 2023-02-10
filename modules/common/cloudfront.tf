resource "aws_cloudfront_distribution" "mirumi_me" {
  count = var.env_name == "prd" ? 1 : 0

  origin {
    domain_name = "${aws_s3_bucket.mirumi_me[count.index].id}.s3-website-ap-northeast-1.amazonaws.com"
    origin_id   = aws_s3_bucket.mirumi_me[count.index].id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    custom_header {
      name  = "Referer"
      value = aws_s3_bucket.mirumi_me[count.index].bucket_domain_name
    }
  }

  # aliases             = ["mirumi.me"]
  default_root_object = "index.html"
  enabled             = true

  viewer_certificate {
    cloudfront_default_certificate = true
  }
  # viewer_certificate {
  #   cloudfront_default_certificate = var.env_name == "dev" ? true : null
  #   acm_certificate_arn            = var.env_name == "dev" ? null : var.acm_arn_mirumi_me
  #   minimum_protocol_version       = var.env_name == "dev" ? null : "TLSv1.2_2021"
  #   ssl_support_method             = var.env_name == "dev" ? null : "sni-only"
  # }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"  # CachingOptimized
    target_origin_id       = aws_s3_bucket.mirumi_me[count.index].id
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"  # CachingOptimized
    target_origin_id       = aws_s3_bucket.mirumi_me[count.index].id
    compress               = true
    path_pattern           = "/_nuxt/*"
    viewer_protocol_policy = "redirect-to-https"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/assets/404.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.tags
}

resource "aws_cloudfront_distribution" "mirumi_media" {
  count = var.env_name == "prd" ? 1 : 0

  origin {
    domain_name = aws_s3_bucket.mirumi_media[count.index].bucket_regional_domain_name
    origin_id   = aws_s3_bucket.mirumi_media[count.index].id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.mirumi_media[count.index].cloudfront_access_identity_path
    }
  }

  aliases = ["mirumi.media"]
  enabled = true

  viewer_certificate {
    cloudfront_default_certificate = var.env_name == "dev" ? true : null
    acm_certificate_arn            = var.env_name == "dev" ? null : var.acm_arn_mirumi_media
    minimum_protocol_version       = var.env_name == "dev" ? null : "TLSv1.2_2021"
    ssl_support_method             = var.env_name == "dev" ? null : "sni-only"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "b2884449-e4de-46a7-ac36-70bc7f1ddd6d"  # CachingOptimizedForUncompressedObjects
    target_origin_id       = aws_s3_bucket.mirumi_media[count.index].id
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.tags
}

resource "aws_cloudfront_origin_access_identity" "mirumi_media" {
  count   = var.env_name == "prd" ? 1 : 0
  comment = "mirumi.media for assets of mirumi.me"
}



resource "aws_cloudfront_cache_policy" "caching_optimized_and_additional_headers" {
  # For API Gateway

  count = var.env_name == "prd" ? 1 : 0

  name        = "${var.resource_prefix}-${var.env_name}-caching-optimized-and-additional-headers"
  comment     = "The follow headers included (cache spec is same as CachingOptimized): `Origin`, `Authorization`, `Referer`"
  min_ttl     = 1
  max_ttl     = 31536000
  default_ttl = 86400
  
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "all"
    }

    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Authorization", "Origin", "Referer"]
      }
    }

    query_strings_config {
      query_string_behavior = "all"
    }

    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}
