resource "aws_route53_zone" "primary" {
  name    = var.domain_name
  comment = "Managed by Terraform"
  tags = {
    Environment = var.environment
    Site        = var.domain_name
  }
}

resource "aws_route53_record" "a-record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "aaaa-record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "AAAA"
  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cname" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "300"
  records = [var.domain_name]
}

output "route53_zone_id" {
  value = aws_route53_zone.primary.zone_id
}

output "route53_name_servers" {
  value = aws_route53_zone.primary.name_servers
}

