output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.name
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.app_template.id
}
