resource "aws_ecs_cluster" "self" {
  name = "${var.product}-${local.workspace}"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "self" {
  cluster_name = aws_ecs_cluster.self.name

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_account_setting_default" "taskLongArnFormat" {
  name  = "taskLongArnFormat"
  value = "enabled"
}

resource "aws_ecs_account_setting_default" "serviceLongArnFormat" {
  name  = "serviceLongArnFormat"
  value = "enabled"
}

resource "aws_ecs_account_setting_default" "awsvpcTrunking" {
  name  = "awsvpcTrunking"
  value = "enabled"
}

resource "aws_ecs_account_setting_default" "containerInstanceLongArnFormat" {
  name  = "containerInstanceLongArnFormat"
  value = "enabled"
}

resource "aws_ecs_account_setting_default" "containerInsights" {
  name  = "containerInsights"
  value = "disabled"
}