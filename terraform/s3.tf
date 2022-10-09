#==================================================
# S3バケット
#==================================================
resource "aws_s3_bucket" "diglive_private" {
  bucket        = "diglive-private"
  force_destroy = true
}

resource "aws_s3_bucket" "diglive_public" {
  bucket        = "diglive-public"
  force_destroy = true
}

resource "aws_s3_bucket" "diglive_log" {
  bucket        = "diglive-log"
  force_destroy = true
}


#==================================================
# private
#==================================================
# バージョニング
resource "aws_s3_bucket_versioning" "diglive_private" {
  bucket = aws_s3_bucket.diglive_private.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 暗号化
resource "aws_s3_bucket_server_side_encryption_configuration" "diglive_private" {
  bucket = aws_s3_bucket.diglive_private.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# パブリックアクセスブロック
resource "aws_s3_bucket_public_access_block" "diglive_private" {
  bucket                  = aws_s3_bucket.diglive_private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


#==================================================
# public
#==================================================
# CORS
resource "aws_s3_bucket_cors_configuration" "diglive_public" {
  bucket = aws_s3_bucket.diglive_public.id

  cors_rule {
    allowed_origins = ["https://dig-live.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}

# ACL
resource "aws_s3_bucket_acl" "diglive_public" {
  bucket = aws_s3_bucket.diglive_public.id

  acl = "public-read"
}

#==================================================
# log
#==================================================
# ライフサイクルルール
resource "aws_s3_bucket_lifecycle_configuration" "diglive_log" {
  bucket = aws_s3_bucket.diglive_log.id

  rule {
    id = "log"

    expiration {
      days = 180
    }
    status = "Enabled"
  }
}

# バケットポリシー
resource "aws_s3_bucket_policy" "diglive_log" {
  bucket = aws_s3_bucket.diglive_log.id
  policy = data.aws_iam_policy_document.diglive_log.json
}
