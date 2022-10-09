#==================================================
# ECRリポジトリ
#==================================================
# resource "aws_ecr_repository" "diglive_api" {
#   name = "diglive-api"
# }

resource "aws_ecr_repository" "diglive_front" {
  name = "diglive-front"
}

#==================================================
# ECRライフサイクルポリシー
#==================================================
# resource "aws_ecr_lifecycle_policy" "diglive_api" {
#   repository = aws_ecr_repository.diglive_api.name

#   policy = <<EOF
#   {
#     "rules": [
#       {
#         "rulePriority": 1,
#         "description": "Keep last 30 release tagged images",
#         "selection": {
#           "tagStatus": "tagged",
#           "tagPrefixList": ["release"],
#           "countType": "imageCountMoreThan",
#           "countNumber": 30
#         },
#         "action": {
#           "type": "expire"
#         }
#       }
#     ]
#   }
#   EOF
# }

resource "aws_ecr_lifecycle_policy" "diglive_front" {
  repository = aws_ecr_repository.diglive_front.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep last 30 release tagged images",
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