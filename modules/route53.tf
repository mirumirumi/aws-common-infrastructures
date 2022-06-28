resource "aws_route53_zone" "kei_ooo" {
  name  = "kei.ooo"
  count = var.env_name == "prd" ? 1 : 0

  tags = var.tags
}

resource "aws_route53_record" "kei_ooo_A" {
  zone_id = aws_route53_zone.kei_ooo[count.index].zone_id
  name    = "kei.ooo"
  type    = "A"

  alias {
    name                   = "d2i1p1l37l2o59.cloudfront.net."
    zone_id                = "Z2FDTNDATAQYW2"  # https://stackoverflow.com/questions/39665214/get-hosted-zone-for-cloudfront-distribution
    evaluate_target_health = false
  }

  count = var.env_name == "prd" ? 1 : 0
}
