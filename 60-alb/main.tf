module "main" {
  source = "terraform-aws-modules/alb/aws"

  name     = local.resource_name
  internal = false
  vpc_id   = local.vpc_id
  subnets  = local.subnet_ids

  create_security_group = false
  security_groups       = [local.sg_id]

  enable_deletion_protection = false

  tags = merge(
    local.common_tags,
    { Name = local.resource_name },
    var.tags
  )
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = module.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>I'am ingress ALB</h1>"
      status_code  = "200"
    }
  }
}

module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = local.zone_name

  records = [
    {
      name = local.resource_name
      type = "A"
      alias = {
        name    = module.main.dns_name
        zone_id = module.main.zone_id
      }
      allow_overwrite = true
    }
  ]
}

resource "aws_lb_target_group" "expense" {
  name        = local.resource_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    matcher             = "200-299"
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 4
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.expense.arn
  }

  condition {
    host_header {
      values = ["${local.resource_name}.${local.zone_name}"]
    }
  }
}

output "target_group_arn" {
  value = aws_lb_target_group.expense.arn
}