# resource "aws_cloudwatch_event_rule" "imdb-sync" {
#   name                = "${var.product}-${local.workspace}-imdb-sync"
#   description         = "Run IMDB Sync Container"
#   schedule_expression = "cron(0 0 ? * SUN *)"
# }

# resource "aws_cloudwatch_event_target" "imdb-sync" {
#   target_id = "${var.product}-${local.workspace}-imdb-sync"
#   arn       = aws_ecs_cluster.self.arn
#   rule      = aws_cloudwatch_event_rule.imdb-sync.name
#   role_arn  = aws_iam_role.ecs-events.arn

#   ecs_target {
#     task_count          = 1
#     task_definition_arn = aws_ecs_task_definition.imdb-sync.arn
#   }

# }

# resource "aws_ecs_task_definition" "imdb-sync" {

#   family                   = "${var.product}-${local.workspace}-imdb-sync"
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   cpu                      = 512
#   memory                   = 1024
#   execution_role_arn       = aws_iam_role.task-execution.arn
#   task_role_arn            = aws_iam_role.task.arn

#   container_definitions = jsonencode([
#     {
#       name        = "sync",
#       image       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/torrent-ninja/master/imdb-sync:latest",
#       environment = [
#         {
#           Name  = "RDS_DB"
#           Value = "torrent_ninja"
#         }
#       ]
#       secrets = [
#         {
#           name      = "RDS_HOST"
#           valueFrom = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.product}/${local.workspace}/infra/rds/host"
#         },
#         {
#           name      = "RDS_USER"
#           valueFrom = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.product}/${local.workspace}/infra/rds/user"
#         },
#         {
#           name      = "RDS_PASS"
#           valueFrom = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.product}/${local.workspace}/infra/rds/pass"
#         }
#       ],
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           "awslogs-group"         = "/${var.product}/${local.workspace}/imdb-sync/ImdbNameBasics",
#           "awslogs-region"        = data.aws_region.current.name,
#           "awslogs-create-group"  = "true",
#           "awslogs-stream-prefix" = "log_router"
#         }
#       }
#     }
#   ])
# }