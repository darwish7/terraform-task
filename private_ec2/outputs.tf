output "private-ec2-ips" {
  value = aws_instance.private_ec2[*].id
}
