output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_1_id" {
  value = module.vpc.public_subnet_1_id
}

output "public_subnet_2_id" {
  value = module.vpc.public_subnet_2_id
}

output "private_subnet_1_id" {
  value = module.vpc.private_subnet_1_id
}

output "private_subnet_2_id" {
  value = module.vpc.private_subnet_2_id
}

output "private_subnet_db_1" {
  value = module.vpc.private_subnet_db_1
}

output "private_subnet_db_2" {
  value = module.vpc.private_subnet_db_2
}

output "db_instance_id" {
  value = module.rds.db_instance_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
