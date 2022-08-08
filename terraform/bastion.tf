
resource "aws_security_group" "bastion" {
  name        = "/${var.product}/${local.workspace}/bastion"
  description = "/${var.product}/${local.workspace}/bastion"
  vpc_id      = aws_vpc.self.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "/${var.product}/${local.workspace}/bastion"
  }
}

resource "aws_iam_role" "bastion" {

  name_prefix = "${var.product}-${local.workspace}-bastion-"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "bastion" {
  role       = aws_iam_role.nat.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "bastion" {
  name_prefix = "${var.product}-${local.workspace}-bastion"
  role = aws_iam_role.nat.name
}


# resource "aws_instance" "bastion" {
#   ami                         = data.aws_ssm_parameter.ami.value
#   associate_public_ip_address = true
#   ebs_optimized               = true
#   iam_instance_profile        = aws_iam_instance_profile.bastion.name
#   source_dest_check           = true
#   subnet_id                   = aws_subnet.public[0].id
#   vpc_security_group_ids      = [  aws_security_group.bastion.id ]
#   key_name                    = var.product

#   instance_type               = "t3a.nano"

#   tags = {
#     Name = "/${var.product}/${local.workspace}/bastion"
#   }
# }