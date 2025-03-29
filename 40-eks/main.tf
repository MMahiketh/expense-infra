resource "aws_key_pair" "eks" {
  key_name   = "eks"
  public_key = file("~/.ssh/eks.pub")
}

module "main" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = local.resource_name
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids

  control_plane_subnet_ids = local.subnet_ids

  create_cluster_security_group = false
  cluster_security_group_id     = local.cluster_sg_id

  create_node_security_group = false
  node_security_group_id     = local.node_sg_id

  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    # blue = {
    #   max_size      = 10
    #   min_size      = 2
    #   desired_size  = 2
    #   capacity_type = "SPOT"
    #   iam_role_additional_policies = {
    #     AmazonEBSCSIDriverPolicy       = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    #     AmazonEFSCSIDriverPolicy       = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
    #     ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
    #   }
    #   key_name = resource.aws_key_pair.eks.key_name
    # }

    green = {
      max_size      = 10
      min_size      = 2
      desired_size  = 2
    #   capacity_type = "SPOT"
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy       = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEFSCSIDriverPolicy       = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
      }
      key_name = resource.aws_key_pair.eks.key_name
    }
  }

  enable_cluster_creator_admin_permissions = true

  tags = merge(
    local.common_tags,
    { Name = local.resource_name },
    var.tags
  )
}
