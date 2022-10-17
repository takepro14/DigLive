#==================================================
# ECS タスク実行用ロール
#==================================================
# ポリシーを参照
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 権限を追加されたポリシーを参照
data "aws_iam_policy_document" "ecs_task_execution" {
  # "source_json": 既存ポリシーを継承できる
  source_json = data.aws_iam_policy.ecs_task_execution_role_policy.policy

  # SSMパラメータストアとECSの統合
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }
}

module "diglive_ecs_task_exec" {
  source = "./iam_role"
  name   = "diglive-ecs-task-exec"
  # ECSで利用することを宣言する
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution.json
}

#==================================================
# ECS Exec実行用ロール
#==================================================
data "aws_iam_policy_document" "diglive_ecs_task_role" {
  version = "2012-10-17"
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

module "diglive_ecs_task_role" {
  source     = "./iam_role"
  name       = "diglive-ecs-task-role"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.diglive_ecs_task_role.json
}


#==================================================
# CloudWatch イベント用ロール
#==================================================
# module "ecs_events_role" {
#   source = "./iam_role"
#   name = "ecs-events"
#   identifier = "events.amazonaws.com"
#   policy = data.aws_iam_policy.ecs_events_role_policy.policy
# }

# data "aws_iam_policy" "ecs_events_role_policy" {
#   arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
# }


#==================================================
# S3 オブジェクトput用ロール
#==================================================
data "aws_iam_policy_document" "diglive_log" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.diglive_log.id}/*"
    ]

    # 適用対象
    principals {
      type = "AWS"
      # 東京リージョンのAWSアカウントID(ALBで利用)
      identifiers = ["582318560864"]
    }
  }
}
