#==================================================
# クラスター
#==================================================
resource "aws_ecs_cluster" "diglive" {
  name = "diglive"
}

#==================================================
# タスク定義
#==================================================
resource "aws_ecs_task_definition" "diglive_front" {
  family                   = "diglive-front"
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./tasks/diglive_front_container_definitions.json")
  execution_role_arn       = module.diglive_ecs_task_exec.iam_role_arn
  task_role_arn            = module.diglive_ecs_task_role.iam_role_arn
}

resource "aws_ecs_task_definition" "diglive_api" {
  family                   = "diglive-api"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./tasks/diglive_api_container_definitions.json")
  execution_role_arn       = module.diglive_ecs_task_exec.iam_role_arn
  task_role_arn            = module.diglive_ecs_task_role.iam_role_arn
}

resource "aws_ecs_task_definition" "diglive_db_create" {
  family                   = "diglive-db-create"
  container_definitions    = file("./tasks/diglive_db_create_definition.json")
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = module.diglive_ecs_task_exec.iam_role_arn
}
resource "aws_ecs_task_definition" "diglive_db_migrate" {
  family                   = "diglive-db-migrate"
  container_definitions    = file("./tasks/diglive_db_migrate_definition.json")
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = module.diglive_ecs_task_exec.iam_role_arn
}
resource "aws_ecs_task_definition" "diglive_db_migrate-reset" {
  family                   = "diglive-db-migrate-reset"
  container_definitions    = file("./tasks/diglive_db_migrate_reset_definition.json")
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = module.diglive_ecs_task_exec.iam_role_arn
}

#==================================================
# サービス
#==================================================
resource "aws_ecs_service" "diglive_front" {
  name                              = "diglive-front"
  cluster                           = aws_ecs_cluster.diglive.arn
  task_definition                   = aws_ecs_task_definition.diglive_front.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0" # ecs Exec使用のため1.4.0以降
  enable_execute_command            = true    # ecs execの実行許可
  health_check_grace_period_seconds = 600

  network_configuration {
    assign_public_ip = true
    security_groups = [
      aws_security_group.diglive_ecs.id
    ]

    subnets = [
      aws_subnet.diglive_public_1a.id,
      aws_subnet.diglive_public_1c.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.diglive_front.arn
    container_name   = "diglive-front"
    container_port   = 80
  }

  lifecycle {
    # Fargateではデプロイのたびにタスク定義が更新されるため変更を無視する
    ignore_changes = [task_definition]
  }

  depends_on = [aws_lb_listener.diglive_http]
}

resource "aws_ecs_service" "diglive_api" {
  name                   = "diglive-api"
  cluster                = aws_ecs_cluster.diglive.arn
  task_definition        = aws_ecs_task_definition.diglive_api.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  platform_version       = "1.4.0" # ecs Exec使用のため1.4.0以降
  enable_execute_command = true    # ecs execの実行許可

  network_configuration {
    assign_public_ip = true
    security_groups = [
      aws_security_group.diglive_ecs.id
    ]

    subnets = [
      aws_subnet.diglive_public_1a.id,
      aws_subnet.diglive_public_1c.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.diglive_api.arn
    container_name   = "diglive-api"
    container_port   = 3000
  }

  lifecycle {
    # Fargateではデプロイのたびにタスク定義が更新されるため変更を無視する
    ignore_changes = [task_definition]
  }
}

#==================================================
# タスク実行ロール
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
# タスクロール
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
