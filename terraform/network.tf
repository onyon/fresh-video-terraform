resource "aws_vpc" "self" {
  cidr_block            = var.cidr
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = {
    Name = "/${var.product}/${local.workspace}"
  }
}

resource "aws_internet_gateway" "self" {
  vpc_id = aws_vpc.self.id
}

resource "aws_subnet" "public" {
  count                   = length(var.availability_zone)

  vpc_id                  = aws_vpc.self.id
  cidr_block              = cidrsubnet(aws_vpc.self.cidr_block, 4, count.index)
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "/${var.product}/${var.availability_zone[count.index]}/public"
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.availability_zone)

  vpc_id                  = aws_vpc.self.id
  cidr_block              = cidrsubnet(aws_vpc.self.cidr_block, 4, count.index + length(var.availability_zone))
  availability_zone       = var.availability_zone[count.index]

  tags = {
    Name = "/${var.product}/${var.availability_zone[count.index]}/private"
  }
}

resource "aws_subnet" "isolate" {
  count                   = length(var.availability_zone)

  vpc_id                  = aws_vpc.self.id
  cidr_block              = cidrsubnet(aws_vpc.self.cidr_block, 4, count.index + (length(var.availability_zone) * 2))
  availability_zone       = var.availability_zone[count.index]

  tags = {
    Name = "/${var.product}/${var.availability_zone[count.index]}/isolate"
  }
}

resource "aws_security_group" "nat" {
  name        = "/${var.product}/${local.workspace}/nat"
  description = "/${var.product}/${local.workspace}/nat"
  vpc_id      = aws_vpc.self.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ aws_vpc.self.cidr_block ]
  }

  tags = {
    Name = "/${var.product}/${local.workspace}/nat"
  }
}

resource "aws_route_table" "public" {
  vpc_id  = aws_vpc.self.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.self.id
  }

  tags = {
    Name        = "/${var.product}/${local.workspace}/public"
  }
}

resource "aws_route_table" "private" {
  count   = length(var.availability_zone)
  vpc_id  = aws_vpc.self.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat[count.index].id
  }

  tags = {
    Name = "/${var.product}/${local.workspace}/${var.availability_zone[count.index]}/private"
  }
}

resource "aws_route_table" "isolate" {
  vpc_id  = aws_vpc.self.id

  tags = {
    Name = "/${var.product}/${local.workspace}/isolate"
  }
}

resource "aws_route_table_association" "public" {
  count           = length(var.availability_zone)
  subnet_id       = aws_subnet.public[count.index].id
  route_table_id  = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count           = length(var.availability_zone)
  subnet_id       = aws_subnet.private[count.index].id
  route_table_id  = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "isolate" {
  count           = length(var.availability_zone)
  subnet_id       = aws_subnet.isolate[count.index].id
  route_table_id  = aws_route_table.isolate.id
}