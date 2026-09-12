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

variable "security_group_id" {
  description = "The security group ID for the RDS instance"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets to use for the DB subnet group"
  type        = list(string)
}

variable "subnet_group_name" {
  description = "The name of the DB subnet group"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the DB"
  type        = bool
  default     = true
}