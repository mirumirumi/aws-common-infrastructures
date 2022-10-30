resource "aws_cloudfront_cache_policy" "caching_optimized_and_more" {
  name        = "${var.resource_prefix}-${var.env_name}-caching-optimized-and-more"
  comment     = "dev and prd are same"
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
