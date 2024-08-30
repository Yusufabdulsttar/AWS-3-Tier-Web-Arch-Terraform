# Module for VPC setup
module "vpc" {
  source                         = "./modules/vpc"
  cidr_block_vpc                 = "10.0.0.0/16"
  cidr_block_public_subnet_1     = "10.0.1.0/24"
  cidr_block_public_subnet_2     = "10.0.2.0/24"
  cidr_block_private_subnet_1    = "10.0.3.0/24"
  cidr_block_private_subnet_2    = "10.0.4.0/24"
  cidr_block_private_subnet_db_1 = "10.0.5.0/24"
  cidr_block_private_subnet_db_2 = "10.0.6.0/24"
  availability_zone_1            = var.availability_zone_1
  availability_zone_2            = var.availability_zone_2
}

# Module for Security Group setup
module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

# Module for RDS setup
module "rds" {
  source               = "./modules/rds"
  db_username          = "admin"
  db_password          = "password"
  db_subnet_id_1       = module.vpc.private_subnet_db_1
  db_subnet_id_2       = module.vpc.private_subnet_db_2
  db_security_group_id = module.security_group.db_security_group_id
}


# Module for ALB setup
module "alb" {
  source                    = "./modules/alb"
  vpc_id                    = module.vpc.vpc_id
  public_subnet_1_id        = module.vpc.public_subnet_1_id
  public_subnet_2_id        = module.vpc.public_subnet_2_id
  private_subnet_1_id       = module.vpc.private_subnet_1_id
  private_subnet_2_id       = module.vpc.private_subnet_2_id
  alb_app_security_group_id = module.security_group.alb_app_security_group_id
  alb_web_security_group_id = module.security_group.alb_web_security_group_id
}


# Module for asg setup
module "asg" {
  source                   = "./modules/asg"
  launch-template-app-name = "App"
  launch-template-web-name = "Web"
  aws_lb_target_group_web  = module.alb.alb-web_target_group
  aws_lb_target_group_app  = module.alb.alb_app_target_group
  image-id                 = "ami-0440fa9465661a496"
  instance-type            = "t2.micro"
  sg-web-id                = module.security_group.asg_security_group_web_id
  sg-app-id                = module.security_group.asg_security_group_app_id
  public_subnet_1_id       = module.vpc.public_subnet_1_id
  public_subnet_2_id       = module.vpc.public_subnet_2_id
  private_subnet_1_id      = module.vpc.private_subnet_1_id
  private_subnet_2_id      = module.vpc.private_subnet_2_id
  alb_App_dns_name         = module.alb.alb_App_dns_name
  region                   = var.region
  rds_address              = module.rds.rds_address
  db_name                  = module.rds.rds_db_name
  rds_db_admin             = module.rds.db_username
  rds_db_password          = module.rds.db_password
}
