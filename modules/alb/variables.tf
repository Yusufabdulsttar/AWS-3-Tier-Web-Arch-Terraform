variable "vpc_id" {
  description = "The VPC ID where the ALB will be deployed"
  type        = string
}

variable "alb_web_security_group_id" {
  description = "The security group ID for the ALB in web tier"
  type        = string
}

variable "alb_app_security_group_id" {
  description = "The security group ID for the ALB in app tier"
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
