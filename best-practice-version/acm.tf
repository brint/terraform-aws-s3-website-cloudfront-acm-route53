resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "EMAIL"

  # Terraform requires ACM certs for CloudFront to be generated in us-east-1
  # regardless of the region your S3 bucket or any other resources are.
  provider = aws.virginia

  tags = {
    Environment = var.environment
    Site        = var.domain_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "acm_arn" {
  value = aws_acm_certificate.cert.arn
}

output "acm_domain_name" {
  value = aws_acm_certificate.cert.domain_name
}

