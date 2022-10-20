#==================================================
# S3バケット(画像アップロード用)
#==================================================
resource "aws_s3_bucket" "diglive_public_image" {
  bucket = "diglive-public-image"
  tags = {
    Name = "diglive-public-image"
  }
}

resource "aws_s3_bucket_acl" "diglive_public_image" {
  bucket = aws_s3_bucket.diglive_public_image.id
  acl    = "public-read"
}

#==================================================
# S3バケット(ログ出力用)
#==================================================
resource "aws_s3_bucket" "diglive_private_log" {
  bucket = "diglive-private-log"
}

resource "aws_s3_bucket_lifecycle_configuration" "diglive_private_log" {
  bucket = aws_s3_bucket.diglive_private_log.id

  rule {
    id = "log"

    expiration {
      days = 180
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "diglive_private_log" {
  bucket = aws_s3_bucket.diglive_private_log.id
  policy = data.aws_iam_policy_document.diglive_private_log.json
}
