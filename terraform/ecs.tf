####################################################################################################
# Elastic Container Service
####################################################################################################

#==================================================
# クラスタ
#==================================================
resource "aws_ecs_cluster" "dig-live" {
  name = "dig-live"
}

#==================================================
# サービス
#==================================================
resource "aws_ecs_service" "dig-live" {
  name = "dig-live"
  cluster = aws_ecs_cluster.dig-live.arn
  task_definition = aws_ecs_task_definition.dig-live.arn
  # ECSサービスが維持するタスク数
  desired_count = 2
  launch_type = "FARGATE"
  platform_version = "1.3.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups = [module.nginx_sg.security_group_id]

    subnets = [
      aws_subnet.private_0.id,
      aws_subnet.private_1.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.dig-live.arn
    container_name = "dig-live"
    container_port = 80
  }

  lifecycle {
    # Fargateではデプロイのたびにタスク定義が更新されるため変更を無視する
    ignore_changes = [task_definition]
  }

  depends_on = [aws_lb_listener.http]
}

module "nginx_sg" {
  source = "./security_group"
  name = "nginx-sg"
  vpc_id = aws_vpc.dig-live.id
  port = 80
  cidr_blocks = [aws_vpc.dig-live.cidr_block]
}

#==================================================
# タスク定義
#==================================================
resource "aws_ecs_task_definition" "dig-live" {
  # タスク定義名: example:1, 2, 3, ...
  family = "dig-live"
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = file("./container_definitions.json")
  # Dockerコンテナのロギング
  execution_role_arn = module.ecs_task_execution_role.iam_role_arn
}

# # バッチ用
# resource "aws_ecs_task_definition" "dig-live_batch" {
#   family = "dig-live-batch"
#   cpu = "256"
#   memory = "512"
#   network_mode = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   container_definitions = file("./batch_container_definitions.json")
#   # Dockerコンテナのロギング
#   execution_role_arn = module.ecs_task_execution_role.iam_role_arn
# }




#==================================================
# ECSタスク実行ロールの参照
#==================================================
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#==================================================
# ECSタスク実行用IAMロールの参照
#==================================================
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

#==================================================
# ECSタスク実行ロールの作成
#==================================================
module "ecs_task_execution_role" {
  source = "./iam_role"
  name = "ecs-task-execution"
  identifier = "ecs-tasks.amazonaws.com"
  policy = data.aws_iam_policy_document.ecs_task_execution.json
}
