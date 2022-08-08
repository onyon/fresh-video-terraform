# resource "aws_iam_role" "ecs-events" {
#   name_prefix = "${var.product}-${local.workspace}-"

#   assume_role_policy = <<DOC
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "events.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# DOC
# }

# resource "aws_iam_role_policy" "ecs-events" {
#   name = "ecs_events_run_task_with_any_role"
#   role = aws_iam_role.ecs-events.id

#   policy = <<DOC
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "iam:PassRole",
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": "ecs:RunTask",
#             "Resource": [
#               "${replace(aws_ecs_task_definition.imdb-sync.arn, "/:\\d+$/", ":*")}"
#             ]
#         }
#     ]
# }
# DOC
# }