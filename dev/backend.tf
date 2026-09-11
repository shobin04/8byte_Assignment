terraform {
  backend "s3" {
    bucket       = "terraformbucketstate-shobin-8byte-2026"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt      = true
  }
}