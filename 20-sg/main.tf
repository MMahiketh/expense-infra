module "mysql" {
  source = "git::https://github.com/MMahiketh/terraform-sg-module.git?ref=master"

  project     = var.project
  environment = var.environment
  instance    = "mysql"
  vpc_id      = local.vpc_id
}

module "node" {
  source = "git::https://github.com/MMahiketh/terraform-sg-module.git?ref=master"

  project     = var.project
  environment = var.environment
  instance    = "node-group"
  vpc_id      = local.vpc_id
}

module "control_plane" {
  source = "git::https://github.com/MMahiketh/terraform-sg-module.git?ref=master"

  project     = var.project
  environment = var.environment
  instance    = "control-plane"
  vpc_id      = local.vpc_id
}

module "bastion" {
  source = "git::https://github.com/MMahiketh/terraform-sg-module.git?ref=master"

  project     = var.project
  environment = var.environment
  instance    = "bastion"
  vpc_id      = local.vpc_id
}

module "ingress_alb" {
  source = "git::https://github.com/MMahiketh/terraform-sg-module.git?ref=master"

  project     = var.project
  environment = var.environment
  instance    = "ingress-alb"
  vpc_id      = local.vpc_id
}