
terraform {
  backend "s3" {
    bucket         = "terraform-state-975049978724-ap-south-1-prod"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1" # or your region
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}