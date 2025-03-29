data "aws_ssm_parameter" "vpc_id" {
  name = "${local.ssm_prefix}/vpc/id"
}

data "aws_ssm_parameter" "subnet_ids" {
  name = "${local.ssm_prefix}/private/subnet/ids"
}

data "aws_ssm_parameter" "cluster_sg_id" {
  name = "${local.ssm_prefix}/control_plane/sg_id"
}

data "aws_ssm_parameter" "node_sg_id" {
  name = "${local.ssm_prefix}/node/sg_id"
}