resource "aws_db_parameter_group" "default" {
  name   = "${var.product}-${local.workspace}"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  parameter {
    name         = "innodb_autoinc_lock_mode"
    value        = "0"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "${var.product}-${local.workspace}-private"
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_db_subnet_group" "public" {
  name       = "${var.product}-${local.workspace}-public"
  subnet_ids = aws_subnet.public.*.id
}

resource "aws_security_group" "rds" {
  name        = "/${var.product}/${local.workspace}/rds"
  description = "/${var.product}/${local.workspace}/rds"
  vpc_id      = aws_vpc.self.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "Database Access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "/${var.product}/${local.workspace}/rds"
  }
}

resource "random_password" "rds_password" {
  length           = 32
  special          = false
}

resource "aws_db_instance" "self" {
  identifier                  = "${var.product}-${local.workspace}"
  allocated_storage           = 32
  apply_immediately           = true
  auto_minor_version_upgrade  = true
  db_subnet_group_name        = aws_db_subnet_group.public.name
  delete_automated_backups    = true
  multi_az                    = true
  parameter_group_name        = aws_db_parameter_group.default.name
  publicly_accessible         = true
  storage_encrypted           = true
  storage_type                = "gp2"
  vpc_security_group_ids      = [ aws_security_group.rds.id ]

  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = "db.t4g.micro"
  db_name                     = replace(var.product, "-", "_")
  username                    = "root"
  password                    = random_password.rds_password.result
  skip_final_snapshot         = true

}