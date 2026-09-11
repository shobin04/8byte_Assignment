output "private_ip" {
  value = aws_instance.private_server.private_ip
}

output "private_instance_id" {
  value = aws_instance.private_server.id
}