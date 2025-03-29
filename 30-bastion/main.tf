module "main" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami  = local.ami_id
  name = "${local.resource_name}-bastion"

  instance_type          = var.instance_type
  key_name               = "linux-key devops shiva"
  vpc_security_group_ids = [local.sg_id]
  subnet_id              = local.subnet_id

  user_data = file("setup.sh")

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_name}-bastion" },
    var.tags
  )
}

# configure aws credentials in bastion
resource "null_resource" "config_eks" {
  triggers = {
    instance_id = module.main.id
  }

  connection {
    host        = module.main.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/devops-shiva/linux-key")
  }

  provisioner "remote-exec" {
    inline = [
      "aws configure set aws_access_key_id ${var.aws_access_key}",
      "aws configure set aws_secret_access_key ${var.aws_secret_key}",
      "aws configure set default.region ${var.aws_default_region}",
      "curl -sS https://webinstall.dev/k9s | bash",
      "git clone https://github.com/MMahiketh/k8s-expense.git"
    ]
  }
}

resource "aws_route53_record" "workstation" {
  zone_id         = local.zone_id
  name            = "bastion.${local.zone_name}"
  type            = "A"
  ttl             = 300
  records         = [module.main.public_ip]
  allow_overwrite = true
}