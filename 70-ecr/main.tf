#Locals
locals {
  resource_name = "${var.project}/${var.environment}"
}

resource "aws_ecr_repository" "backend" {
  name                 = "${local.resource_name}/backend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "frontend" {
  name                 = "${local.resource_name}/frontend"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}