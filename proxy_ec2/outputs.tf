output "proxy-ips" {
  value = aws_instance.proxy_ec2[*].id
}
