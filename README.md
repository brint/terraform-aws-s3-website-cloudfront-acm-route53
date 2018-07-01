# terraform-aws-s3-website-cloudfront-acm-route53

This is a setup for hosting a static website leveraging the following AWS services:

- S3
- CloudFront
- Route 53
- ACM

This repo exists because I spent a fair amount of time stitching this together and it took a while to get to the setup I typically run. This is going to be my starter kit for new static websites.

A lot of what's in here I did find in gists, repos, and blog posts of folks along with the terraform docs. Thank you all for sharing. Apologies, as I didn't do a good job of keeping track of all places where I was able to get snippets to give credit.

## Setup

1. Install [terraform](https://www.terraform.io/)
1. My environment has all of my AWS credentials set in `~/.aws/credentials` which terraform leverages.


## Usage

1. Update `variables.tf` to reflect your site configuration
1. Run `terraform init` to initialize everything.
1. Run `terraform plan` to see what terraform is going to do.
1. Run `terraform apply` to have it setup the infrastructure

## Troubleshooting

Not a lot to put here, if resources exist such as zones in Route53 or buckets in S3, you will need to use different buckets. ACM also makes the assumption that you are the owner of the domain and can sign off on a certificate being used. With ACM, you may need to run `terraform apply` multiple times since the ACM cert may not be ready by the time terraform is setting up CloudFront.
