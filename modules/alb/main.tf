
// ALB for Web Tier
resource "aws_lb" "ALB-Web" {
  name               = "ALB-Web"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_web_security_group_id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

  tags = {
    Name = "ALB-Web"
  }
}

# a listener on the ALB
resource "aws_lb_listener" "alb-web_listener" {
  load_balancer_arn = aws_lb.ALB-Web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-web_target_group.arn
  }
}

# a target group for ALB to asg
resource "aws_lb_target_group" "alb-web_target_group" {
  name     = "alb-web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    matcher             = "200"
  }

  tags = {
    Name = "alb-web_target_group"
  }
}

// ALB for App Tier
resource "aws_lb" "ALB-App" {
  name               = "ALB-App"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.alb_app_security_group_id]
  subnets            = [var.private_subnet_1_id, var.private_subnet_2_id]

  tags = {
    Name = "ALB-App"
  }
}

# a listener on the ALB
resource "aws_lb_listener" "alb-app_listener" {
  load_balancer_arn = aws_lb.ALB-App.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_app_target_group.arn
  }
}

# a target group for ALB to asg
resource "aws_lb_target_group" "alb_app_target_group" {
  name     = "alb-app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    matcher             = "200"
  }

  tags = {
    Name = "alb-app_target_group"
  }
}
