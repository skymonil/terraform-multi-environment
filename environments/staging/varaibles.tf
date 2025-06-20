# VPC VARIABLES
###################################################################

variable "region" {
  type    = string
  default = ""
}


variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = []
}



variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = ""
}


variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}


###################################################################

# S3 VARIABLES

variable "bucket_name" {
 description = "Name of the s3 bucket"
 type = string
}

###################################################################

# CDN Variables

variable "domain_alias" {
  description = "CloudFront alias domain (e.g., '615915.xyz' or 'staging.615915.xyz')"
  type        = string
}







variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate (must cover both domains and be in us-east-1)"
  type        = string
}

variable "alb_acm_certificate_arn" {
  description = "ARN of the ACM certificate (must cover both domains and be in us-east-1)"
  type        = string
}

########################################


########################################

## ALB VARIABLES





############################


## ASG VARAIBLES
variable "ami_id" {
  description = "ARN of the ACM certificate (must cover both domains and be in us-east-1)"
  type        = string
}
variable "HCP_CLIENT_SECRET" {
  description = "HCP_CLIENT_SECRET"
  type        = string
}
variable "HCP_CLIENT_ID" {
  description = "HCP_CLIENT_ID"
  type        = string
}
variable "instance_type" {
  description = "instance_type"
  type        = string
}

variable "desired_capacity" {
   description = "desired_capactiy"
  type        = string
}
variable "max_size" {
   description = "max_size"
  type        = string
}

variable "min_size" {
   description = "min_size"
  type        = string
}



variable "app_name" {
   description = "app_name"
  type        = string
}