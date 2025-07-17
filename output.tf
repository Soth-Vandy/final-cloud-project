output "elb_dns_name" {
  value       = aws_lb.web_alb.dns_name
  description = "DNS name of the Application Load Balancer"
}

output "elb_target_group_arn" {
  value       = aws_lb_target_group.web_tg.arn
  description = "The ARN of the ELB target group"
}