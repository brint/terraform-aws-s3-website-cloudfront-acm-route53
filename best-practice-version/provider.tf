provider "aws" {
  region = "${var.aws_region}"
  version = "~> 1.25"
}

# For ACM with CloudFront in Terraform, must be in us-east-1
provider "aws" {
  alias = "virginia"
  region = "us-east-1"
  version = "~> 1.25"
}