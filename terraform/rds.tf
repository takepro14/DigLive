# #==================================================
# # DBパラメータグループ
# #==================================================
# resource "aws_db_parameter_group" "diglive" {
#   name = "diglive"
#   family = "mysql5.7"

#   parameter {
#     name = "character_set_database"
#     value = "utf8mb4"
#   }

#   parameter {
#     name = "character_set_server"
#     value = "utf8mb4"
#   }
# }

# #==================================================
# # DBオプショングループ
# #==================================================
# resource "aws_db_option_group" "diglive" {
#   name = "diglive"
#   engine_name = "mysql"
#   major_engine_version = "5.7"

#   option {
#     option_name = "MARIADB_AUDIT_PLUGIN"
#   }
# }

# #==================================================
# # DBサブネットグループ
# #==================================================
# resource "aws_db_subnet_group" "diglive" {
#   name = "diglive"
#   subnet_ids = [
#     aws_subnet.diglive_private_1a.id,
#     aws_subnet.diglive_private_1c.id
#   ]
# }

# #==================================================
# # DBインスタンス
# #==================================================
# resource "aws_db_instance" "diglive" {
#   identifier = "diglive"
#   engine = "mysql"
#   engine_version = "5.7"
#   instance_class = "db.t3.small"
#   allocated_storage = 20
#   max_allocated_storage = 100
#   storage_type = "gp2"
#   storage_encrypted = true
#   kms_key_id = aws_kms_key.diglive.arn
#   username = "admin"
#   password = "VeryStrongPassword!"
#   multi_az = true
#   publicly_accessible = false
#   backup_window = "09:10-09:40"
#   backup_retention_period = 30
#   maintenance_window = "mon:10:10-mon:10:40"
#   auto_minor_version_upgrade = false
#   deletion_protection = true
#   skip_final_snapshot = false
#   port = 3306
#   apply_immediately = false
#   vpc_security_group_ids = [module.diglive_sg_rds_mysql.security_group_id]
#   parameter_group_name = aws_db_parameter_group.diglive.name
#   option_group_name = aws_db_option_group.diglive.name
#   db_subnet_group_name = aws_db_subnet_group.diglive.name

#   # パスワードはaws cliで変更するためignoreする
#   lifecycle {
#     ignore_changes = [password]
#   }
# }
