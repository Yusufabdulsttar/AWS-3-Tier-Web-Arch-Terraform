// sg for web tier
resource "aws_security_group" "asg_security_group_web" {
  name        = "asg-security-group-web"
  description = "Security group for instances in public subnet"
  vpc_id      = var.vpc_id  

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_web_security_group.id]
  }

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Egress rules (allow all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-group-web"
  }
}

resource "aws_security_group" "alb_web_security_group" {
  name        = "alb web security group"
  description = "ALB Security Group For Web Tier"
  vpc_id      = var.vpc_id  

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb web security group"
  }
}

// sg for app tier
resource "aws_security_group" "asg_security_group_app" {
  name        = "asg-security-group-app"
  description = "Security group for instances in private subnet"
  vpc_id      = var.vpc_id  

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_app_security_group.id]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.asg_security_group_web.id]
  }

  // Egress rules (allow all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-group-app"
  }
}

resource "aws_security_group" "alb_app_security_group" {
  name        = "alb app security group"
  description = "ALB Security Group For app Tier"
  vpc_id      = var.vpc_id  

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.asg_security_group_web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb app security group"
  }
}

//for DB
resource "aws_security_group" "db_sg" {
  name        = "db_security_group"
  description = "Security group for RDS database"
  vpc_id      = var.vpc_id  

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.asg_security_group_app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security group for RDS database"
  }
}