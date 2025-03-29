# internet --> bastion
resource "aws_security_group_rule" "internet_bastion" {
  type              = "ingress"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.id
}

resource "aws_security_group_rule" "bastion_node" {
  type                     = "ingress"
  from_port                = var.ssh_port
  to_port                  = var.ssh_port
  protocol                 = "tcp"
  source_security_group_id = module.bastion.id
  security_group_id        = module.node.id
}

resource "aws_security_group_rule" "bastion_control_plane" {
  type                     = "ingress"
  from_port                = var.https_port
  to_port                  = var.https_port
  protocol                 = "tcp"
  source_security_group_id = module.bastion.id
  security_group_id        = module.control_plane.id
}

resource "aws_security_group_rule" "control_plane_node" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.control_plane.id
  security_group_id        = module.node.id
}

resource "aws_security_group_rule" "node_control_plane" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.node.id
  security_group_id        = module.control_plane.id
}

resource "aws_security_group_rule" "node_node" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.node.id
  security_group_id        = module.node.id
}

resource "aws_security_group_rule" "node_mysql" {
  type                     = "ingress"
  from_port                = var.mysql_port
  to_port                  = var.mysql_port
  protocol                 = "tcp"
  source_security_group_id = module.node.id
  security_group_id        = module.mysql.id
}

resource "aws_security_group_rule" "ingress_alb_node" {
  type                     = "ingress"
  from_port                = var.nodeport_start
  to_port                  = var.nodeport_end
  protocol                 = "tcp"
  source_security_group_id = module.ingress_alb.id
  security_group_id        = module.node.id
}

resource "aws_security_group_rule" "internet_ingress_alb" {
  type              = "ingress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ingress_alb.id
}