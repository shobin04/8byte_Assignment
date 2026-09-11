variable "instance_id" {
  description = "The ID of the EC2 instance to monitor"
  type        = string
}

variable "alarm_action_arn" {
  description = "ARN of the action to execute when the alarm is triggered"
  type        = string
}

variable "ok_action_arn" {
  description = "ARN of the action to execute when the alarm is OK"
  type        = string
}

