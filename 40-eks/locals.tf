locals {
  resource_name = "${var.project}-${var.environment}"
  ssm_prefix    = "/${var.project}/${var.environment}"

  vpc_id     = data.aws_ssm_parameter.vpc_id.value
  subnet_ids = split(",", data.aws_ssm_parameter.subnet_ids.value)

  cluster_sg_id = data.aws_ssm_parameter.cluster_sg_id.value
  node_sg_id    = data.aws_ssm_parameter.node_sg_id.value

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }
}