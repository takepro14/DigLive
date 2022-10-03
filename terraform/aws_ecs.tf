####################################################################################################
# Elastic Container Service
####################################################################################################

# #==================================================
# # クラスタ
# #==================================================
# resource "aws_ecs_cluster" "example" {
#   name = "example"
# }

# #==================================================
# # サービス
# #==================================================
# resource "aws_ecs_service" "example" {
#   name = "example"
#   cluster = aws_ecs_cluster.example.arn
#   task_definition = aws_ecs_task_definition.example.arn
#   # ECSサービスが維持するタスク数
#   desired_count = 2
#   launch_type = "FARGATE"
#   platform_version = "1.3.0"
#   health_check_grace_period_seconds = 60

#   network_configuration {
#     assign_public_ip = false
#     security_groups = [module.nginx_sg.security_group_id]

#     subnets = [
#       aws_subnet.private_0.id,
#       aws_subnet.private_1.id
#     ]
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.example.arn
#     container_name = "example"
#     container_port = 80
#   }

#   lifecycle {
#     # Fargateではデプロイのたびにタスク定義が更新されるため変更を無視する
#     ignore_changes = [task_definition]
#   }

#   depends_on = [aws_lb_listener.http]
# }

# module "nginx_sg" {
#   source = "./security_group"
#   name = "nginx-sg"
#   vpc_id = aws_vpc.example.id
#   port = 80
#   cidr_blocks = [aws_vpc.example.cidr_block]
# }

# #==================================================
# # タスク定義
# #==================================================
# resource "aws_ecs_task_definition" "example" {
#   # タスク定義名: example:1, 2, 3, ...
#   family = "example"
#   cpu = "256"
#   memory = "512"
#   network_mode = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   container_definitions = file("./container_definitions.json")
# }

