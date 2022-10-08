# resource "aws_cloudwatch_log_group" "for_ecs" {
#   name = "/ecs/diglive"
#   # ログの保管期間
#   retention_in_days = 180
# }

# #=================================================
# # バッチ用CloudWatch Logs
# #=================================================
# resource "aws_cloudwatch_log_group" "for_ecs_scheduled_tasks" {
#   name = "/ecs-scheduled-tasks/diglive"
#   retention_in_days = 180
# }


# #=================================================
# # CloudWatchイベントルール
# #=================================================
# resource "aws_cloudwatch_event_rule" "diglive_batch"  {
#   name = "diglive-batch"
#   description = "とても重要なバッチ処理です"
#   schedule_expression = "cron(*/2 * * * ? *)"
# }

# #=================================================
# # CloudWatchイベントターゲット
# #=================================================
# resource "aws_cloudwatch_event_target" "diglive_batch" {
#   target_id = "diglive-batch"
#   rule = aws_cloudwatch_event_rule.diglive_batch.name
#   role_arn = module.ecs_events_role.iam_role_arn
#   arn = aws_ecs_cluster.diglive.arn

#   ecs_target {
#     launch_type = "FARGATE"
#     task_count = 1
#     platform_version = "1.3.1"
#     task_definition_arn = aws_ecs_task_definition.diglive_api_batch.arn

#     network_configuration {
#       assign_public_ip = "false"
#       subnets = [aws_subnet_private_0.id]
#     }
#   }
# }

