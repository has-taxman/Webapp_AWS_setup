#########################################################
# Load Balancer and Target Group Configuration
#########################################################

# Create the Application Load Balancer.
resource "aws_lb" "app_lb" {
  name               = "multi-tier-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnets

  tags = {
    Name = "MultiTier-ALB"
  }
}

# Create a target group for the Node.js instances.
resource "aws_lb_target_group" "app_tg" {
  name     = "multi-tier-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  # Health check configuration.
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "MultiTier-TG"
  }
}

# Create a listener for the ALB on port 80.
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.app_tg.arn
    type             = "forward"
  }
}

# Outputs for use by the autoscaling module and root.
output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.app_lb.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.app_tg.arn
}
