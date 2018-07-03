resource "aws_s3_bucket" "website" {
  bucket = "${var.bucket_name}"
  acl = "public-read"

  tags {
    Environment = "${var.environment}"
    Site = "${var.domain_name}"
  }

  cors_rule {
    allowed_headers = ["Authorizations"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers = ["ETag"]
    max_age_seconds = 3000
  }

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadGetObject",
    "Effect":"Allow",
    "Principal": "*",
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::${var.bucket_name}/*"]
  }]
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

output "s3_bucket_website_endpoint" {
  value = "${aws_s3_bucket.website.website_endpoint}"
}
