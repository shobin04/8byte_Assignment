resource "aws_instance" "bastion" {
  ami             = var.bastion_ami
  instance_type   = var.instance_type
  subnet_id       = var.public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  associate_public_ip_address = true
  key_name = var.key_name
  tags = {
    Name = var.bastion_name
  }
}
