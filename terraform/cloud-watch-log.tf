# ####################################################################################################
# # CloudWatch Logs
# ####################################################################################################
# resource "aws_cloudwatch_log_group" "for_ecs" {
#   name = "/ecs/dig-live"
#   # ログの保管期間
#   retention_in_days = 180
# }

# #==================================================
# # バッチ用CloudWatch Logs
# #==================================================
# resource "aws_cloudwatch_log_group" "for_ecs_scheduled_tasks" {
#   name = "/ecs-scheduled-tasks/dig-live"
#   retention_in_days = 180
# }

# #==================================================
# # CloudWatchイベントIAMロール
# #==================================================
# module "ecs_events_role" {
#   source = "./iam_role"
#   name = "ecs-events"
#   identifier = "events.amazonaws.com"
#   policy = data.aws_iam_policy.ecs_events_role_policy.policy
# }

# data "aws_iam_policy" "ecs_events_role_policy" {
#   arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
# }

# #==================================================
# # CloudWatchイベントルール
# #==================================================
# resource "aws_cloudwatch_event_rule" "dig-live_batch"  {
#   name = "dig-live-batch"
#   description = "とても重要なバッチ処理です"
#   schedule_expression = "cron(*/2 * * * ? *)"
# }

# #==================================================
# # CloudWatchイベントターゲット
# #==================================================
# resource "aws_cloudwatch_event_target" "dig-live_batch" {
#   target_id = "dig-live-batch"
#   rule = aws_cloudwatch_event_rule.dig-live_batch.name
#   role_arn = module.ecs_events_role.iam_role_arn
#   arn = aws_ecs_cluster.dig-live.arn

#   ecs_target {
#     launch_type = "FARGATE"
#     task_count = 1
#     platform_version = "1.3.1"
#     task_definition_arn = aws_ecs_task_definition.dig-live_batch.arn

#     network_configuration {
#       assign_public_ip = "false"
#       subnets = [aws_subnet_private_0.id]
#     }
#   }
# }

