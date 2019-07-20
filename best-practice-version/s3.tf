resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Environment = var.environment
    Site        = var.domain_name
  }

  cors_rule {
    allowed_headers = ["Authorizations"]

    # Running a static website, wouldn't expect any method outside of GET
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "PolicyForCloudFrontPrivateContent",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }
  ]
}
EOF


  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket" "cfn_logging_bucket" {
  bucket = var.logs_bucket_name
  acl = "log-delivery-write"

  lifecycle_rule {
    enabled = true

    expiration {
      days = var.logs_retention_duration
    }
  }

  tags = {
    Environment = var.environment
    Site = var.domain_name
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.website.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.website.arn
}

output "s3_bucket_domain_name" {
  value = aws_s3_bucket.website.bucket_domain_name
}

output "s3_cfn_logging_bucket_arn" {
  value = aws_s3_bucket.cfn_logging_bucket.arn
}

output "s3_cfn_logging_bucket_domain_name" {
  value = aws_s3_bucket.cfn_logging_bucket.bucket_domain_name
}

