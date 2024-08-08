// For web tier
resource "aws_launch_template" "template-web" {
  name_prefix     = var.launch-template-web-name
  image_id        = var.image-id
  instance_type   = var.instance-type
  user_data = filebase64("data.sh")
 
  network_interfaces {
    device_index    = 0
    security_groups = [var.sg-web-id]
  }

  tag_specifications { 
    resource_type = "instance"
    tags = {
      Name = "Web_Server"
    }
  }
}

resource "aws_autoscaling_group" "autoscale-web" {
  name                  = "autoscaling-web"  
  desired_capacity      = 2
  max_size              = 4
  min_size              = 1
  health_check_type     = "EC2"
  termination_policies  = ["OldestInstance"]
  target_group_arns     = [var.aws_lb_target_group_web.arn]
  vpc_zone_identifier   = [var.public_subnet_1_id, var.public_subnet_2_id]

  launch_template {
    id      = aws_launch_template.template-web.id
    version = aws_launch_template.template-web.latest_version
  }
}

// For App tier
resource "aws_launch_template" "template-app" {
  name_prefix   = var.launch-template-app-name
  image_id      = var.image-id
  instance_type = var.instance-type
  user_data = filebase64("data.sh")

  network_interfaces {
    device_index    = 0
    security_groups = [var.sg-app-id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "App"
    }
  }
}

resource "aws_autoscaling_group" "asg-app" {
  name                = "asg-app"
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  health_check_type   = "EC2"
  termination_policies  = ["OldestInstance"]
  target_group_arns   = [var.aws_lb_target_group_app.arn]
  vpc_zone_identifier = [var.private_subnet_1_id, var.private_subnet_2_id]


  launch_template {
    id      = aws_launch_template.template-app.id
    version = aws_launch_template.template-app.latest_version
  }
}
