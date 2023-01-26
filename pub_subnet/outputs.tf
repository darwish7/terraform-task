output "subnet-id" {
 value = values(aws_subnet.pub_subnet)[*].id
}
