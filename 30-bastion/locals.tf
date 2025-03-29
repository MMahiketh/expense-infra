locals {
  resource_name = "${var.project}-${var.environment}"
  ssm_prefix    = "/${var.project}/${var.environment}"
  ami_id        = data.aws_ami.az_linux.id
  subnet_id     = split(",", data.aws_ssm_parameter.subnet_ids.value)[0]
  sg_id         = data.aws_ssm_parameter.sg_id.value

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }

  zone_name = "mahdo.site"
  zone_id   = "Z02855522FE67JKRUDSDP"
}