variable "instance_type" {
  description = "instance type for bastion and private app"
  type = string
}

variable "bastion_ami" {
  description = "ami for bastion"
  type = string
}

variable "bastion_name" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "bastion_sg_id" {
  type = string
}