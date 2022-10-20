#==================================================
# ECS タスク実行ロール
#==================================================
/* タスク実行ロール(ビルトイン)の参照  */
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

/* SSMパラメータストア参照権限の統合 */
data "aws_iam_policy_document" "ecs_task_execution" {
  source_json = data.aws_iam_policy.ecs_task_execution_role_policy.policy

  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }
}

/* タスク実行ロールの作成 */
module "diglive_ecs_task_exec" {
  source     = "./iam_role"
  name       = "diglive-ecs-task-exec"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution.json
}

#==================================================
# ECS タスクロール
#==================================================
/* ECS Exec用ポリシーの設定 */
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

/* タスクロールの作成 */
module "diglive_ecs_task_role" {
  source     = "./iam_role"
  name       = "diglive-ecs-task-role"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.diglive_ecs_task_role.json
}

#==================================================
# S3 ログ出力用ロール
#==================================================
data "aws_iam_policy_document" "diglive_private_log" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.diglive_private_log.id}/*"
    ]

    principals {
      type = "AWS"
      # 東京リージョンのAWSアカウントID(ALBで利用)
      identifiers = ["582318560864"]
    }
  }
}
