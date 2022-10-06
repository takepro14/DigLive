####################################################################################################
# Key Management Service
####################################################################################################
#==================================================
# カスタマーマスターキー
#==================================================
resource "aws_kms_key" "dig-live" {
  description = "dig-live Customer Master Key"
  enable_key_rotation = true
  is_enabled = true
  deletion_window_in_days = 30
}

#==================================================
# エイリアス
#==================================================
resource "aws_kms_alias" "dig-live" {
  name = "alias/dig-live"
  target_key_id = aws_kms_key.dig-live.key_id
}
