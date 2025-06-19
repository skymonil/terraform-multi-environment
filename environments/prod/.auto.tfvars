
# VPC VARIABLES
##################################################

vpc_cidr_block= "192.168.128.0/22"
vpc_name="caam-prod-vpc"
environment="prod"
availability_zones=["ap-south-1a","ap-south-1b"]
public_subnet_cidrs=["192.168.130.0/24","192.168.131.0/24"]
private_subnet_cidrs=["192.168.128.0/24","192.168.129.0/24"]

##################################################

# S3 VARIABLES
##################################################
bucket_name="caam-prod-bucket"


##################################################
domain_alias="615915.xyz"
acm_certificate_arn="arn:aws:acm:us-east-1:975049978724:certificate/32cc7aa7-e9b5-4761-afed-141b780f189a"

alb_acm_certificate_arn="arn:aws:acm:ap-south-1:975049978724:certificate/aae9e11b-0a3c-4e21-bd97-8473ffab83bd"
ami_id="ami-0ae0bfa220651da22"
 HCP_CLIENT_ID="nXohCz1vvyMWdoRnhGzPSi1ijKVP2orP"
HCP_CLIENT_SECRET="RXGVY_K9wlhSbcr9s4HQ7bwZaR0I8PHVtXSa5A7tN1U7qp9zpt7jU29avg91oaEU"
instance_type="t2.micro"
min_size         = 2
desired_capacity = 3
max_size         = 5
app_name="caam-app"