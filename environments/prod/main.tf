module "vpc" {
  source = "../../modules/vpc"
  vpc_name = var.vpc_name
  environment = var.environment
  availability_zones = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  vpc_cidr_block = var.vpc_cidr_block
  region = var.region
  enable_private_subnets = true
  enable_nat = true
}

module "s3" {
  source = "../../modules/s3"
  bucket_name = var.bucket_name
  environment = var.environment

}

module "cdn" {
  source      = "../../modules/cdn"
  s3_bucket_id= module.s3.bucket_id
  s3_bucket_arn = module.s3.bucket_arn
  environment = var.environment
  s3_bucket_regional_domain_name = module.s3.s3_bucket_regional_domain_name
  domain_alias = var.domain_alias
  acm_certificate_arn = var.acm_certificate_arn
}
 
resource "aws_s3_bucket_policy" "cf_access" {
  bucket = module.s3.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action    = ["s3:GetObject"]
        Resource  = "${module.s3.bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = module.cdn.cloudfront_distribution_arn
          }
        }
      }
    ]
  })
}

module "alb" {
  source = "../../modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  environment = var.environment
  alb_acm_certificate_arn = var.alb_acm_certificate_arn

}

module "asg" {
  source                  = "../../modules/asg"
  app_name                = var.app_name
  ami_id                  = var.ami_id
  instance_type           = var.instance_type
  environment             = var.environment
  security_group_ids      = [module.alb.alb_target_sg_id]  # assuming output from alb module
  subnet_ids              = module.vpc.private_subnet_ids
  target_group_arns       = [module.alb.backend_target_group_arn]
  min_size                = var.min_size
  max_size                = var.max_size
  desired_capacity        = var.desired_capacity
  HCP_CLIENT_ID           = var.HCP_CLIENT_ID
  HCP_CLIENT_SECRET       = var.HCP_CLIENT_SECRET
}



