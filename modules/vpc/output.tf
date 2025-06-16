output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = try(aws_subnet.public_subnets[*].id,[])
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
   value       = try(aws_subnet.private_subnets[*].id,[])
}