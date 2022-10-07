##################################################
# Erastic Container Registry
##################################################

#=================================================
# ECRリポジトリ
#=================================================
resource "aws_ecr_repository" "diglive" {
  name = "diglive"
}

#=================================================
# ECRライフサイクルポリシー
#=================================================
resource "aws_ecr_lifecycle_policy" "diglive" {
  repository = aws_ecr_repository.diglive.name

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