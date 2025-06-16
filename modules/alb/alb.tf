resource "aws_lb" "shared_alb" {
  name               = "shared-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.environment == "prod" ? true : false

  tags = {
    Name        = "shared-${var.environment}-alb"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_lb_target_group" "backend_prod" {
  name     = "backend-prod-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/health"
    port = "5000"
  }

  tags = {
    Environment = "prod"
  }
}

resource "aws_lb_target_group" "backend_staging" {
  name     = "backend-staging-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/health"
    port = "5000"
  }

  tags = {
    Environment = "staging"
  }
}


resource "aws_lb_listener_rule" "prod_rule" {
  listener_arn = aws_lb_listener.https.arn
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

resource "aws_lb_listener_rule" "staging_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_staging.arn
  }

  condition {
    host_header {
      values = ["api-staging.615915.xyz"]
    }
  }
}
