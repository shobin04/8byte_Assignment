variable "name" {
  description = "The name of the load balancer"
  type        = string
}

variable "security_groups" {
  description = "The security groups to associate with the load balancer"
  type        = list(string)
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the load balancer"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where the load balancer and target group will be created"
  type        = string
}

variable "target_group_name" {
  description = "The name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "The port for the target group"
  type        = number
}

variable "target_instance_ids" {
  description = "The IDs of the instances to attach to the target group"
  type        = list(string)
}

variable "listener_port" {
  description = "The port for the load balancer listener"
  type        = number
}