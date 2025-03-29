locals {
  resource_name = "${var.project}-${var.environment}"
  ssm_prefix    = "/${var.project}/${var.environment}"

  sg_id      = data.aws_ssm_parameter.sg_id.value
  vpc_id     = data.aws_ssm_parameter.vpc_id.value
  subnet_ids = split(",", data.aws_ssm_parameter.subnet_ids.value)

  certificate_arn = data.aws_ssm_parameter.certificate_arn.value

  zone_name = "mahdo.site"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }
}