output "subnet-id" {
  value = values(aws_subnet.private_subnet)[*].id
}
