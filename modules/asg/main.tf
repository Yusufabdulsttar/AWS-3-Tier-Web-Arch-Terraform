// For web tier
resource "aws_launch_template" "template-web" {
  name_prefix   = var.launch-template-web-name
  image_id      = var.image-id
  instance_type = var.instance-type
  key_name      = aws_key_pair.key.key_name
  //user_data     = filebase64("data.sh")
  user_data = base64encode(templatefile("./user-data/user-data-presentation-tier.sh", {
    application_load_balancer = var.alb_App_dns_name,
    region                    = var.region
  }))

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
  name                 = "autoscaling-web"
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  health_check_type    = "EC2"
  termination_policies = ["OldestInstance"]
  target_group_arns    = [var.aws_lb_target_group_web.arn]
  vpc_zone_identifier  = [var.public_subnet_1_id, var.public_subnet_2_id]

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
  key_name      = aws_key_pair.key.key_name
  //user_data     = filebase64("data.sh")

   user_data = base64encode(templatefile("./user-data/user-data-application-tier.sh", {
    rds_hostname  = var.rds_address,
    rds_username  = var.rds_db_admin,
    rds_password  = var.rds_db_password,
    rds_port      = 3306,
    rds_db_name   = var.db_name,
    region        = var.region
  }))

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
  name                 = "asg-app"
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  health_check_type    = "EC2"
  termination_policies = ["OldestInstance"]
  target_group_arns    = [var.aws_lb_target_group_app.arn]
  vpc_zone_identifier  = [var.private_subnet_1_id, var.private_subnet_2_id]


  launch_template {
    id      = aws_launch_template.template-app.id
    version = aws_launch_template.template-app.latest_version
  }
}

#keypair for ssh

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key" {
  key_name   = "key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "key"
}
