##################################################
# Identity and Access Management
##################################################

#=================================================
# ECS
#=================================================
# タスク実行ロールの参照
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_execution" {
  # 既存ポリシーを継承
  source_policy_documents = [data.aws_iam_policy.ecs_task_execution_role_policy.policy]

  # SSMパラメータストアとECSの統合で必要な権限を追加
  statement {
    effect = "Allow"
    actions = ["ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }
}

module "ecs_task_execution_role" {
  source = "./iam_role"
  name = "ecs-task-execution"
  identifier = "ecs-tasks.amazonaws.com"
  policy = data.aws_iam_policy_document.ecs_task_execution.json
}

# #=================================================
# # EC2
# #=================================================
# module "describe_regions_for_ec2" {
#   source = "./iam_role"
#   name = "describe-regions-for-ec2"
#   identifier = "ec2.amazonaws.com"
#   policy = data.aws_iam_policy_document.allow_describe_regions.json
# }

# #=================================================
# # CloudWatchイベントIAMロール
# #=================================================
# module "ecs_events_role" {
#   source = "./iam_role"
#   name = "ecs-events"
#   identifier = "events.amazonaws.com"
#   policy = data.aws_iam_policy.ecs_events_role_policy.policy
# }

# data "aws_iam_policy" "ecs_events_role_policy" {
#   arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
# }
