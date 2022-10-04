####################################################################################################
# Simple Storage Service
####################################################################################################
#==================================================
# プライベート
#==================================================
# バケット本体
resource "aws_s3_bucket" "private" {
  bucket = "private-haribotake-bucket"
  force_destroy = true
}

# バージョニング
resource "aws_s3_bucket_versioning" "private" {
  bucket = aws_s3_bucket.private.id
  versioning_configuration {
    status = "Enabled"
  }
}

# オブジェクトの暗号化
resource "aws_s3_bucket_server_side_encryption_configuration" "private" {
  bucket = aws_s3_bucket.private.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#==================================================
# パブリック
#==================================================
# パブリックアクセスのブロック
resource "aws_s3_bucket_public_access_block" "private" {
  bucket = aws_s3_bucket.private.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "public" {
  bucket = "public-haribotake-bucket"
  force_destroy = true
}

# CORS設定
resource "aws_s3_bucket_cors_configuration" "public" {
  bucket = aws_s3_bucket.public.id

  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}

# ACL設定
resource "aws_s3_bucket_acl" "public" {
  bucket = aws_s3_bucket.public.id

  acl = "public-read"
}


#==================================================
# ログ
#==================================================
resource "aws_s3_bucket" "log" {
  bucket = "log-haribotake-bucket"
  force_destroy = true
}

# ライフサイクルルール
resource "aws_s3_bucket_lifecycle_configuration" "log" {
  bucket = aws_s3_bucket.log.id

  rule {
    id = "log"

    expiration {
      days = 180
    }
    status = "Enabled"
  }
}

# バケットポリシー
resource "aws_s3_bucket_policy" "log" {
  bucket = aws_s3_bucket.log.id
  policy = data.aws_iam_policy_document.log.json
}

data "aws_iam_policy_document" "log" {
  statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.log.id}/*"]

    principals {
      type = "AWS"
      # 東京リージョンのAWSアカウントID(ALBで利用)
      identifiers = ["582318560864"]
    }
  }
}

