output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

# Combines both private subnets so RDS receives subnets in 2 distinct AZs
output "private_subnet_ids" {
  value = [aws_subnet.private_subnets.id, aws_subnet.db_private_subnets.id]
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "igw_id" {
  value = aws_internet_gateway.my_igw.id
}

output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  value = aws_route_table.private_rt.id
}