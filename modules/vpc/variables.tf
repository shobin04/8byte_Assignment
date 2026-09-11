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