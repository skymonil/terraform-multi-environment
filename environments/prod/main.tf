resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-975049978724-ap-south-1-prod"  # Must be globally unique

  tags = {
    Name        = "Terraform State Storage"
    Environment = "infra"
    ManagedBy   = "Terraform"
  }
   lifecycle {
  prevent_destroy = false
}
}

# Explicitly disable public access
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for state recovery
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable default encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
 
}

# Prevent accidental deletion



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


resource "aws_lb_listener_rule" "prod_rule" {
  listener_arn = module.alb.alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_prod.arn
  }

  condition {
    host_header {
      values = ["api.615915.xyz"]
    }
  }
}

resource "aws_lb_target_group" "backend_prod" {
   name     = "backend-${var.environment}-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path = "/health"
    port = "5000"
  }

  tags = {
    Environment = "prod"
  }
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
   target_group_arns = [aws_lb_target_group.backend_prod.arn]
  min_size                = var.min_size
  max_size                = var.max_size
  desired_capacity        = var.desired_capacity
  HCP_CLIENT_ID           = var.HCP_CLIENT_ID
  HCP_CLIENT_SECRET       = var.HCP_CLIENT_SECRET
  
}



