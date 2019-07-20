resource "aws_cloudfront_distribution" "cdn" {
  origin {
    origin_id   = var.domain_name
    domain_name = aws_s3_bucket.website.website_endpoint

    custom_origin_config {
      # The following is dictating what protocol to use in connecting to the
      # origin. This is because the s3-website service only runs HTTP. Your
      # site will still be served via HTTPS from CloudFront.
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # If using route53 aliases for DNS we need to declare it here too,
  # otherwise we'll get 403s.
  aliases = [var.domain_name, "www.${var.domain_name}"]

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  logging_config {
    bucket = aws_s3_bucket.cfn_logging_bucket.bucket_domain_name
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.domain_name

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # The cheapest priceclass
  price_class = "PriceClass_100"

  # This is required to be specified even if it's not used.
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  tags = {
    Environment = var.environment
    Site        = var.domain_name
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.bucket_name
}

output "cloudfront_origin_access_iam_arn" {
  value = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
}

output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.cdn.arn
}

output "cloudfront_distribution_domain" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_distribution_hosted_zone_id" {
  value = aws_cloudfront_distribution.cdn.hosted_zone_id
}

