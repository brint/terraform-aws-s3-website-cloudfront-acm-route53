from diagrams import Diagram
from diagrams.aws.network import CloudFront
from diagrams.aws.network import Route53
from diagrams.aws.storage import S3
from diagrams.aws.security import CertificateManager


with Diagram("Static Website Hosting", show=False):
    [Route53("Zone"), CertificateManager("ACM SSL Cert")] >> CloudFront("CDN") >> S3("Bucket")
