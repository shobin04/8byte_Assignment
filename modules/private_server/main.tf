resource "aws_instance" "private_server" {
  ami             = var.private_ami
  instance_type   = var.private_instance_type
  subnet_id       = var.private_subnet_id
  vpc_security_group_ids = [var.private_sg_id]
  key_name = var.key_name
  tags = {
    Name = var.private_name
  }
}