data "aws_ssm_parameter" "ami" {  
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Task specific role
resource "aws_iam_role" "nat" {

  name_prefix = "${var.product}-${local.workspace}-nat-"

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

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.nat.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "nat" {
  name_prefix = "${var.product}-${local.workspace}-nat"
  role = aws_iam_role.nat.name
}

resource "aws_instance" "nat" {
  count = length(aws_subnet.public)

  ami                         = "ami-0031d527521fcb961"
  associate_public_ip_address = true
  ebs_optimized               = true
  iam_instance_profile        = aws_iam_instance_profile.nat.name
  source_dest_check           = false
  subnet_id                   = aws_subnet.public[count.index].id
  vpc_security_group_ids      = [  aws_security_group.nat.id ]

  instance_type               = "t3a.nano"

  tags = {
    Name = "/${var.product}/${local.workspace}/${var.availability_zone[count.index]}/nat"
  }
}