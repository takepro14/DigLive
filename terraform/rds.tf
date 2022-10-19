#==================================================
# DBサブネットグループ
#==================================================
resource "aws_db_subnet_group" "diglive" {
  name = "diglive"
  subnet_ids = [
    aws_subnet.diglive_private_1a.id,
    aws_subnet.diglive_private_1c.id
  ]
}

#==================================================
# DBインスタンス
#==================================================
resource "aws_db_instance" "diglive" {
  /* エンジン */
  engine         = "postgres"
  engine_version = "14.4"
  /* 設定 */
  identifier = "diglive"
  username   = "admin_user"
  password   = "password"
  /* インスタンス設定 */
  instance_class = "db.t3.micro"
  /* ストレージ */
  storage_type          = "gp2"
  allocated_storage     = 20
  max_allocated_storage = 200
  /* 接続 */
  db_subnet_group_name   = aws_db_subnet_group.diglive.name
  vpc_security_group_ids = [aws_security_group.diglive_rds.id]

  lifecycle {
    prevent_destroy = true
  }
}
