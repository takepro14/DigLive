####################################################################################################
# Identity and Access Management (module)
####################################################################################################
#==================================================
# 入力
#==================================================
variable "name" {}
variable "policy" {}
variable "identifier" {}

#==================================================
# ロールの作成
#==================================================
resource "aws_iam_role" "default" {
  name = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

#==================================================
# ポリシードキュメントの参照
#==================================================
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      # AWSの何のサービスで使うかの紐付け
      identifiers = [var.identifier]
    }
  }
}

#==================================================
# ポリシーの作成
#==================================================
resource "aws_iam_policy" "default" {
  name = var.name
  policy = var.policy
}

#==================================================
# ロールにポリシーをアタッチ
#==================================================
resource "aws_iam_role_policy_attachment" "default" {
  role = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

#==================================================
# 出力
#==================================================
output "iam_role_arn" {
  value = aws_iam_role.default.arn
}

output "iam_role_name" {
  value = aws_iam_role.default.name
}

