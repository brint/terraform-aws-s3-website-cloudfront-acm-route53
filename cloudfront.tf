resource "aws_cloudfront_distribution" "cdn" {
  origin {
    origin_id   = "${var.domain_name}"
    domain_name = "${var.bucket_name}.s3.amazonaws.com"
    s3_origin_config {
    origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }


  # The www alias is important or you'll get 403's.
  aliases = ["${var.domain_name}", "www.${var.domain_name}"]

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.domain_name}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # Redirect all users to the https version of the site.
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
  tags {
    Environment = "${var.environment}"
    Site = "${var.domain_name}"
  }


  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.bucket_name}"
}

output "cloudfront_origin_access_iam_arn" {
  value = "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
}

output "cloudfront_distribution_arn" {
  value = "${aws_cloudfront_distribution.cdn.arn}"
}

output "cloudfront_distribution_domain" {
  value = "${aws_cloudfront_distribution.cdn.domain_name}"
}

output "cloudfront_distribution_hosted_zone_id" {
  value = "${aws_cloudfront_distribution.cdn.hosted_zone_id}"
}
