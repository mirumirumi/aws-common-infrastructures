resource "aws_acm_certificate" "mirumi_tech" {
  provider = aws.useast1

  domain_name       = "mirumi.tech"
  validation_method = "DNS"

  tags = var.tags
}

resource "aws_acm_certificate_validation" "mirumi_tech" {
  provider = aws.useast1

  certificate_arn         = aws_acm_certificate.mirumi_tech.arn
  validation_record_fqdns = [for record in aws_route53_record.mirumi_tech_ACM : record.fqdn]
}



resource "aws_acm_certificate" "kei_ooo" {
  provider = aws.useast1

  domain_name       = "kei.ooo"
  validation_method = "DNS"

  tags = var.tags
}

resource "aws_acm_certificate_validation" "kei_ooo" {
  provider = aws.useast1

  certificate_arn         = aws_acm_certificate.kei_ooo.arn
  validation_record_fqdns = [for record in aws_route53_record.kei_ooo_ACM : record.fqdn]
}
