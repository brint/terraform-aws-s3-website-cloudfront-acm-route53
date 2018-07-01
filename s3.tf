resource "aws_s3_bucket" "website" {
  bucket = "${var.bucket_name}"
  acl = "private"

  tags {
    Environment = "${var.environment}"
    Site = "${var.domain_name}"
  }

  cors_rule {
    allowed_headers = ["Authorizations"]
    # Running a static website, wouldn't expect any method outside of GET
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers = ["ETag"]
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

output "s3_bucket_name" {
  value = "${aws_s3_bucket.website.id}"
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.website.arn}"
}
