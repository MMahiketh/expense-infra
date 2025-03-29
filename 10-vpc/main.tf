module "vpc" {
  source = "git::https://github.com/MMahiketh/terraform-vpc-module.git?ref=master"

  project        = var.project
  environment    = var.environment
  vpc_cidr_block = local.vpc_cidr
  subnet_cidrs   = local.subnet_cidrs
}