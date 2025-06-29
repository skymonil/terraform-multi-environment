variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "environment" {
  description = "Environment (prod or staging)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}



variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs (public or private)"
  type        = list(string)
}

variable "target_group_arns" {
  description = "List of Target Group ARNs for ALB"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
}





variable "HCP_CLIENT_ID" {
  type        = string
  description = "Client ID for HCP"
  sensitive   = true
}

variable "HCP_CLIENT_SECRET" {
  type        = string
  description = "Client Secret for HCP"
  sensitive   = true
}
