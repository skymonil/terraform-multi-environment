resource "aws_lb" "aws_lb" {
  name = "app-alb-${var.environment}"
  internal = false
  load_balancer_type = "application"
  security_groups = var.alb_security_group_ids
  subnets = var.public_subnet_ids

  enable_deletion_protection = false
   tags = {
    Name      = "app-alb-${var.environment}"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "tg-${var.environment}"
  port     = var.target_group_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
   tags = {
    Name      = "tg-${var.environment}"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener" "https" {
  count             = var.acm_certificate_arn != "" ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}