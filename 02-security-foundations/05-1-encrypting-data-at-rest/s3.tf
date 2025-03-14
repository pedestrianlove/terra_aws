data "aws_s3_bucket" "lab_s3_bucket" {
  bucket = "imagebucket"
}

resource "aws_s3_bucket_acl" "lab_s3_bucket_acl" {
  bucket = data.aws_s3_bucket.lab_s3_bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "lab_s3_bucket_object" {
  key        = "clock.png"
  bucket     = data.aws_s3_bucket.lab_s3_bucket.id
  source     = "clock.png"
  kms_key_id = aws_kms_key.lab_kms_key.arn
}

# 最後s3到建acl會卡住，所以再手動接力吧
