data "terraform_remote_state" "prod_alb" {
  backend = "s3"
  config = {
    bucket = "terraform-state-975049978724-ap-south-1-prod"
    key    = "prod/terraform.tfstate"
    region = "ap-south-1"
  }
}