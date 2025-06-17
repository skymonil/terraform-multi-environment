resource "aws_launch_template" "launch_template" {
  name_prefix   = "${var.app_name}-${var.environment}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = var.security_group_ids

  user_data = base64encode(var.user_data)

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.app_name}-${var.environment}"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                      = "${var.app_name}-${var.environment}-asg"
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arns
  force_delete      = true

  tag {
    key                 = "Name"
    value               = "${var.app_name}-${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}
