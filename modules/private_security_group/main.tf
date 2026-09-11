resource "aws_security_group" "private_sg" {
  name        = "private_sg" 
  description = "private sg for the app"
  vpc_id = var.vpc_id

ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}