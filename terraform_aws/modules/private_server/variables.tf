variable "private_instance_type" {
  description = "instance type for bastion and private app"
  type = string
}

variable "private_name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "private_ami" {
  description = "ami for private ec2"
  type = string
}

variable "private_sg_id" {
  type = string
}

variable "vpc_id" {
  type = string
}