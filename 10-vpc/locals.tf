locals {
  ssm_prefix = "/${var.project}/${var.environment}"
  network    = ["public", "private", "database"]

  vpc_cidr = "10.0.0.0/16"

  subnet_cidrs = [
    ["10.0.1.0/24", "10.0.11.0/24", "10.0.21.0/24"],
    ["10.0.2.0/24", "10.0.12.0/24", "10.0.22.0/24"]
  ]
}