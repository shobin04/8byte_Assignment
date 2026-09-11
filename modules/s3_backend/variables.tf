variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "dynamodb_table_name" {
  type        = string
  description = "Name of the DynamoDB table used for Terraform state locking"
  default     = "terraform-state-locks"
}