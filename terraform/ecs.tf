#==================================================
# ECSクラスター
#==================================================
resource "aws_ecs_cluster" "diglive" {
  name = "diglive"
}

#==================================================
# ECSタスク定義
#==================================================
# resource "aws_ecs_task_definition" "diglive_api" {
#   family = "diglive-api"
#   cpu = "256"
#   memory = "512"
#   network_mode = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   container_definitions = file("./container_definitions.json")
#   # Dockerコンテナのロギング
#   execution_role_arn = module.ecs_task_execution_role.iam_role_arn
# }

resource "aws_ecs_task_definition" "diglive_front" {
  family                   = "diglive-front"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions_front.json")
  task_role_arn            = module.diglive_ecs_task_role.iam_role_arn
  execution_role_arn       = module.diglive_ecs_task_exec.iam_role_arn
}

# Batch
# resource "aws_ecs_task_definition" "diglive_batch" {
#   family = "diglive-batch"
#   cpu = "256"
#   memory = "512"
#   network_mode = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   container_definitions = file("./batch_container_definitions.json")
#   # Dockerコンテナのロギング
#   execution_role_arn = module.ecs_task_execution_role.iam_role_arn
# }

#==================================================
# ECSサービス
#==================================================
resource "aws_ecs_service" "diglive_front" {
  name            = "diglive-front" # diglive-front??
  cluster         = aws_ecs_cluster.diglive.arn
  task_definition = aws_ecs_task_definition.diglive_front.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  # ecs Exec使用のため1.4.0以降
  platform_version = "1.4.0"
  # ecs execの実行許可
  enable_execute_command            = true
  health_check_grace_period_seconds = 600

  network_configuration {
    assign_public_ip = true
    security_groups = [
      module.diglive_sg_ecs_front.security_group_id
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
