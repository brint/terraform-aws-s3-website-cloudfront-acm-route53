provider "aws" {
  region = var.aws_region
}

# For ACM with CloudFront in Terraform, must be in us-east-1
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
