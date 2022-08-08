resource "aws_iam_role" "task-execution" {

  name_prefix = "${var.product}-${local.workspace}-taskExecution-"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
  })

  inline_policy {
    name = "secrets_manager"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          "Sid": "AccessToSSM",
          "Action": [
            "ssm:GetParameter",
            "ssm:GetParameters"
          ],
          "Effect": "Allow",
          "Resource": [
            "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.product}/${local.workspace}/*"
          ]
        }
      ]
    })
  }

}

# Allow the ECS task to start
resource "aws_iam_role_policy_attachment" "task-execution" {
  role       = aws_iam_role.task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "cloudwatch-logs" {
  role       = aws_iam_role.task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Task specific role
resource "aws_iam_role" "task" {

  name_prefix = "${var.product}-${local.workspace}-task-"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
  })

  inline_policy {
    name = "secrets_manager"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          "Sid": "AccessToSSM",
          "Action": [
            "ssm:GetParameter",
            "ssm:GetParameters"
          ],
          "Effect": "Allow",
          "Resource": [
            "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.product}/${local.workspace}/*"
          ]
        }
      ]
    })
  }

}