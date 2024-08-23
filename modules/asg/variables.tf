variable "region" {
}

variable "alb_App_dns_name" {
}

variable "launch-template-web-name" {
  type        = string
}

variable "launch-template-app-name" {
  type        = string
}

variable "aws_lb_target_group_web" {

}

variable "aws_lb_target_group_app" {

}

variable "image-id" {
  type        = string
}

variable "instance-type" {
  type        = string
}

variable "sg-web-id" {
  type        = string
}

variable "sg-app-id" {
  type        = string
}

variable "public_subnet_1_id" {
  type        = string
}

variable "public_subnet_2_id" {
  type        = string
}

variable "private_subnet_1_id" {
  type        = string
}

variable "private_subnet_2_id" {
  type        = string
}

variable "rds_address" {

}

variable "rds_db_admin" {
 
}

variable "rds_db_password" {

}

variable "db_name" {

}
