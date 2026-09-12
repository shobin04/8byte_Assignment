output "db_sg_id" {
  value = aws_security_group.db_sg.id  # Assuming aws_security_group.db_sg is the security group for the RDS
}