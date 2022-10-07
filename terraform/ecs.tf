##################################################
# Elastic Container Service
##################################################

#=================================================
# クラスタ
#=================================================
resource "aws_ecs_cluster" "diglive-ecs-cluster" {
  name = "diglive-ecs-cluster"
}

#=================================================
# タスク定義
#=================================================
resource "aws_ecs_task_definition" "diglive-ecs-task-def" {
  family = "diglive"
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions = file("./container_definitions.json")
  # Dockerコンテナのロギング
  execution_role_arn = module.ecs_task_execution_role.iam_role_arn
}

# # バッチ用
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

#=================================================
# サービス
#=================================================
resource "aws_ecs_service" "diglive-ecs-service" {
  name = "diglive-ecs-service"
  cluster = aws_ecs_cluster.diglive-ecs-cluster.arn
  task_definition = aws_ecs_task_definition.diglive-ecs-task-def.arn
  # ECSサービスが維持するタスク数
  desired_count = 2
  launch_type = "FARGATE"
  platform_version = "1.3.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups = [module.nginx_sg.security_group_id]

    subnets = [
      aws_subnet.diglive-sub-private-1a.id,
      aws_subnet.diglive-sub-private-1c.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.diglive-alb-tg.arn
    container_name = "diglive"
    container_port = 80
  }

  lifecycle {
    # Fargateではデプロイのたびにタスク定義が更新されるため変更を無視する
    ignore_changes = [task_definition]
  }

  depends_on = [aws_lb_listener.diglive-alb-listener-http]
}
