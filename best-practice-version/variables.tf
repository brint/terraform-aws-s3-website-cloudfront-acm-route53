variable "aws_region" {
  description = "AWS region to deploy into"
  default     = "us-east-2"
  type        = string
}

variable "domain_name" {
  description = "Name of the website being spun up."
  default     = "brint-example.com"
  type        = string
}

variable "bucket_name" {
  description = "Name of S3 bucket for static website hosting"
  default     = "brint-example.com"
  type        = string
}

variable "logs_bucket_name" {
  description = "Name of S3 bucket for site's CloudFront logs to go to"
  default     = "brint-example.com-logs"
  type        = string
}

variable "logs_retention_duration" {
  description = "How long to maintain CloudFront logs in the S3 bucket before expiring them."
  default     = "90"
  type        = string
}

variable "environment" {
  description = "Name of environment being provisioned, will be used to tag all resources"
  default     = "production"
  type        = string
}

