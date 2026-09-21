output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "bastion_sg_id" {
  value = module.bastion_security_group1.bastion_sg_id
}

output "private_sg_id" {
  value = module.private_security_group.private_sg_id
}

output "bastion_instance_id" {
  value = module.bastion.bastion_instance_id
}

output "private_instance_id" {
  value = module.private_server.private_instance_id
}

output "bastion_public_ip" {
  description = "Public IP of Bastion Host"
  value       = module.bastion.bastion_public_ip
}

output "private_server_ip" {
  description = "Private IP of App Server"
  value       = module.private_server.private_ip
}

output "db_sg_id" {
  value = module.db_security_group.db_sg_id
}

output "dynamodb_table_name" {
  value = module.s3_bucket.dynamodb_table_name
}

output "db_endpoint" {
  description = "The connection endpoint for the RDS PostgreSQL database"
  value       = module.rds_postgres.db_endpoint
}