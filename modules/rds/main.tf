resource "aws_db_instance" "db_instance" {
  db_name                = "db_instance"
  identifier             = "myrdsinstance"
  allocated_storage      = 20 # GB
  engine                 = "mysql"
  engine_version         = "8.0.35"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [var.db_security_group_id]
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [var.db_subnet_id_1,var.db_subnet_id_2]  

  tags = {
    Name = "My DB subnet group"
  }
}