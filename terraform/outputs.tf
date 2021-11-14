# output values allow you to export structured data about your resources

output "alb-dns-name" {
  value = aws_alb.fa-alb.dns_name
}