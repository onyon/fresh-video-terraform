resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.product}/${local.workspace}/${var.application}/vpc/id"
  type  = "String"
  tier  = "Advanced"
  value = aws_vpc.self.id
}

resource "aws_ssm_parameter" "vpc_cidr" {
  name  = "/${var.product}/${local.workspace}/${var.application}/vpc/cidr"
  type  = "String"
  tier  = "Advanced"
  value = aws_vpc.self.cidr_block
}

resource "aws_ssm_parameter" "subnets_public" {
  name  = "/${var.product}/${local.workspace}/${var.application}/vpc/subnets/public"
  type  = "StringList"
  tier  = "Advanced"
  value = join(",", aws_subnet.public.*.id)
}

resource "aws_ssm_parameter" "subnets_private" {
  name  = "/${var.product}/${local.workspace}/${var.application}/vpc/subnets/private"
  type  = "StringList"
  tier  = "Advanced"
  value = join(",", aws_subnet.private.*.id)
}

resource "aws_ssm_parameter" "subnets_isolate" {
  name  = "/${var.product}/${local.workspace}/${var.application}/vpc/subnets/isolate"
  type  = "StringList"
  tier  = "Advanced"
  value = join(",", aws_subnet.isolate.*.id)
}

resource "aws_ssm_parameter" "rds_host" {
  name  = "/${var.product}/${local.workspace}/${var.application}/rds/host"
  type  = "String"
  tier  = "Advanced"
  value = aws_db_instance.self.address
}

resource "aws_ssm_parameter" "rds_user" {
  name  = "/${var.product}/${local.workspace}/${var.application}/rds/user"
  type  = "String"
  tier  = "Advanced"
  value = aws_db_instance.self.username
}

resource "aws_ssm_parameter" "rds_pass" {
  name  = "/${var.product}/${local.workspace}/${var.application}/rds/pass"
  type  = "SecureString"
  tier  = "Advanced"
  value = random_password.rds_password.result
}

resource "aws_ssm_parameter" "rds_db" {
  name  = "/${var.product}/${local.workspace}/${var.application}/rds/db"
  type  = "String"
  tier  = "Advanced"
  value = "fresh_video"
}