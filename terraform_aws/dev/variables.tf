#vpc
variable "vpc_name" {
  description = "name of Vpc"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

#subnets
variable "public_subnet_cidrs" {
  description = "Public Subnet CIDR values"
  type        = list(string)
}

variable "private_subnet_cidr1" {
  description = "Private Subnet CIDR values"
  type        = string
}

variable "private_subnet_cidr2" {
  description = "db private Subnet CIDR values"
  type        = string
}

variable "availability_zones" {
  description = "Availability zone for subnets"
  type        = list(string)
}

variable "availability_zones1" {
  description = "Availability zone for subnets"
  type        = string
}

variable "availability_zones2" {
  description = "Availability zone for subnets"
  type        = string
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  description = "instance type for bastion app"
  type        = string
}

variable "private_instance_type" {
  description = "instance type for private app"
  type        = string
}

variable "bastion_ami" {
  description = "ami for bastion"
  type        = string
}

variable "bastion_name" {
  type = string
}

variable "private_name" {
  type = string
}

variable "private_ami" {
  description = "ami for private ec2"
  type        = string
}

##postgres##
variable "identifier" {
  description = "The identifier for the RDS instance"
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
}

variable "username" {
  description = "The username for the database"
  type        = string
}

##s3##
variable "tags" {
description = "A map of tags to assign to the resource"
type        = map(string)
default     = {}
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}