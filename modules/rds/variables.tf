
variable "db_username" {
  description = "Username for accessing the PostgreSQL instance"
}

variable "db_password" {
  description = "Password for accessing the PostgreSQL instance"
}

variable "db_subnet_id_1" {
  description = "ID of the private subnet where the RDS instance will be deployed"
}

variable "db_subnet_id_2" {
  description = "ID of the private subnet where the RDS instance will be deployed"
}

variable "db_security_group_id" {
  description = "ID of the security group for the RDS instance"
}