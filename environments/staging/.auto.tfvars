
# VPC VARIABLES
##################################################

vpc_cidr_block= "192.168.132.0/22"
vpc_name="caam-staging-vpc"
environment="staging"
availability_zones=["ap-south-1b","ap-south-1a"]
public_subnet_cidrs = [
  "192.168.132.0/24",
  "192.168.133.0/24"
]



##################################################

# S3 VARIABLES
##################################################
bucket_name="caam-staging-bucket"


##################################################
domain_alias="staging.615915.xyz"
acm_certificate_arn="arn:aws:acm:us-east-1:975049978724:certificate/32cc7aa7-e9b5-4761-afed-141b780f189a"

alb_acm_certificate_arn="arn:aws:acm:ap-south-1:975049978724:certificate/aae9e11b-0a3c-4e21-bd97-8473ffab83bd"
ami_id="ami-0ae0bfa220651da22"
 HCP_CLIENT_ID="your-HCP-Client-ID"
HCP_CLIENT_SECRET="your-HCP-secret"
instance_type="t2.micro"
min_size         = 1
desired_capacity = 1
max_size         = 1
app_name="caam-app-staging"