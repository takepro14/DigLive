#=================================================
# サービス提供用
#=================================================
resource "aws_cloudwatch_log_group" "diglive_front" {
  name              = "/ecs/front"
  retention_in_days = 180
}

resource "aws_cloudwatch_log_group" "diglive_api" {
  name              = "/ecs/api"
  retention_in_days = 180
}

#=================================================
# 構築用(単発実行)
#=================================================
resource "aws_cloudwatch_log_group" "diglive_db_create" {
  name              = "/ecs/db-create"
  retention_in_days = 180
}

resource "aws_cloudwatch_log_group" "diglive_db_migrate" {
  name              = "/ecs/db-migrate"
  retention_in_days = 180
}

resource "aws_cloudwatch_log_group" "diglive_db_migrate_reset" {
  name              = "/ecs/db-migrate-reset"
  retention_in_days = 180
}
