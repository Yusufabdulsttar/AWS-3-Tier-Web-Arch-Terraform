output "alb_dns_name" {
  value = aws_lb.ALB-Web.dns_name
}

output "alb_App_dns_name" {
  value = aws_lb.ALB-App.dns_name
}

output "alb_zone_id" {
  value = aws_lb.ALB-Web.zone_id
}

output "alb-web_target_group" {
  value = aws_lb_target_group.alb-web_target_group
}

output "alb_app_target_group" {
  value = aws_lb_target_group.alb_app_target_group
}