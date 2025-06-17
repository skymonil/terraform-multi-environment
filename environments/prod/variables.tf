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

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
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

variable "subnet_name" {
  description = "Base name for subnets"
  type        = string
  default     = ""
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}
