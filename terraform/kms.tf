#==================================================
# カスタマーマスターキー
#==================================================
resource "aws_kms_key" "diglive" {
  description             = "diglive Customer Master Key"
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = 30
}

#==================================================
# エイリアス
#==================================================
resource "aws_kms_alias" "diglive" {
  name          = "alias/diglive"
  target_key_id = aws_kms_key.diglive.key_id
}
