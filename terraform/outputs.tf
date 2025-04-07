output "load_balancer_dns" {
  value = aws_lb.ror_alb.dns_name
}
