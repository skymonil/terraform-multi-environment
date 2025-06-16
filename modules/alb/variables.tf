variable "environment" {
 description = "environemnt name"
 type=string 
}

variable "vpc_id" {
  description = "VPC ID where the ALB is deployed"
  type = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDS"
  type = list(string)
}

variable "alb_security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "target_group_port" {
   description = "Port for the target group (typically 80)"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path for target group"
  type        = string
  default     = "/"
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
  default     = ""
}