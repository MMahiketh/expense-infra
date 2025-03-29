data "aws_ssm_parameter" "vpc_id" {
  name = "${local.ssm_prefix}/vpc/id"
}

data "aws_ssm_parameter" "sg_id" {
  name = "${local.ssm_prefix}/ingress_alb/sg_id"
}

data "aws_ssm_parameter" "subnet_ids" {
  name = "${local.ssm_prefix}/public/subnet/ids"
}

data "aws_ssm_parameter" "certificate_arn" {
  name = "${local.ssm_prefix}/certificate/arn"
}