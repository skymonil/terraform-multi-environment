module "vpc" {
  source = "../../modules/vpc"
  vpc_name = var.vpc_name
  environment = var.environment
  availability_zones = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  vpc_cidr_block = var.vpc_cidr_block
  subnet_name = var.subnet_name
  
}