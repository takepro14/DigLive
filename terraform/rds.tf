####################################################################################################
# Relational Database Service
####################################################################################################
resource "aws_db_parameter_group" "dig-live" {
  name = "dig-live"
  family = "mysql5.7"

  parameter {
    name = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name = "character_set_server"
    value = "utf8mb4"
  }
}

#==================================================
# DBオプション
#==================================================
resource "aws_db_option_group" "dig-live" {
  name = "dig-live"
  engine_name = "mysql"
  major_engine_version = "5.7"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }
}

#==================================================
# DBサブネット
#==================================================
resource "aws_db_subnet_group" "dig-live" {
  name = "dig-live"
  subnet_ids = [
    aws_subnet.private_0.id,
    aws_subnet.private_1.id
  ]
}

#==================================================
# DBインスタンス
#==================================================
resource "aws_db_instance" "dig-live" {
  identifier = "dig-live"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.small"
  allocated_storage = 20
  max_allocated_storage = 100
  storage_type = "gp2"
  storage_encrypted = true
  kms_key_id = aws_kms_key.dig-live.arn
  username = "admin"
  password = "VeryStrongPassword!"
  multi_az = true
  publicly_accessible = false
  backup_window = "09:10-09:40"
  backup_retention_period = 30
  maintenance_window = "mon:10:10-mon:10:40"
  auto_minor_version_upgrade = false
  deletion_protection = true
  skip_final_snapshot = false
  port = 3306
  apply_immediately = false
  vpc_security_group_ids = [module.mysql_sg.security_group_id]
  parameter_group_name = aws_db_parameter_group.dig-live.name
  option_group_name = aws_db_option_group.dig-live.name
  db_subnet_group_name = aws_db_subnet_group.dig-live.name

  # パスワードはaws cliで変更するためignoreする
  lifecycle {
    ignore_changes = [password]
  }
}

#==================================================
# セキュリティグループ
#==================================================
module "mysql_sg" {
  source = "./security_group"
  name = "mysql-sg"
  vpc_id = aws_vpc.dig-live.id
  port = 3306
  cidr_blocks = [aws_vpc.dig-live.cidr_block]
}
