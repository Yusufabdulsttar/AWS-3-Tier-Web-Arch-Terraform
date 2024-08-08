output "asg_security_group_web_id" {
  value = aws_security_group.asg_security_group_web.id
}

output "alb_web_security_group_id" {
  value = aws_security_group.alb_web_security_group.id
}

output "asg_security_group_app_id" {
  value = aws_security_group.asg_security_group_app.id
}

output "alb_app_security_group_id" {
  value = aws_security_group.alb_app_security_group.id
}

output "db_security_group_id" {
  value = aws_security_group.db_sg.id
}