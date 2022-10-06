####################################################################################################
# Erastic Container Registry
####################################################################################################

#==================================================
# ECRリポジトリ
#==================================================
resource "aws_ecr_repository" "dig-live" {
  name = "dig-live"
}

#==================================================
# ECRライフサイクルポリシー
#==================================================
resource "aws_ecr_lifecycle_policy" "dig-live" {
  repository = aws_ecr_repository.dig-live.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "desctiption": "Keep last 30 release tagged images",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["release"],
          "countType": "imageCountMoreThan",
          "countNumber": 30
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
  EOF
}