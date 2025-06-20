output "asg_name" {
  value = aws_autoscaling_group.autoscaling_group.name
}

output "launch_template_id" {
  value = aws_launch_template.launch_template.id
}

output "asg_arn" {
  value = aws_autoscaling_group.autoscaling_group.arn
}
