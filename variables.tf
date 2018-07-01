variable "aws_region" {
  description = "AWS region to deploy into"
  default     = "us-east-2"
  type        = "string"
}

variable "domain_name" {
  description = "Name of the website being spun up."
  default     = "brint-example.com"
  type        = "string"
}

variable "bucket_name" {
  description = "Name of S3 bucket for static website hosting"
  default     = "brint-example.com"
  type        = "string"
}

variable "environment" {
  description = "Name of environment being provisioned, will be used to tag all resources"
  default     = "production"
  type        = "string"
}
