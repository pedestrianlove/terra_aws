# Permissions
resource "aws_s3_bucket_public_access_block" "lab_s3_public_access" {
  bucket = aws_s3_bucket.lab_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "lab_s3_ownership" {
  bucket = aws_s3_bucket.lab_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "lab_s3_bucket_policy" {
  bucket = aws_s3_bucket.lab_s3_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.lab_s3_bucket.id}/*"
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.lab_s3_public_access]
}

# resource "aws_s3_bucket_acl" "lab_s3_acl" {
#   bucket = aws_s3_bucket.lab_s3_bucket.id
#   acl    = "public-read"
#
#   depends_on = [
#     aws_s3_bucket_public_access_block.lab_s3_public_access,
#     aws_s3_bucket_ownership_controls.lab_s3_ownership,
#     aws_s3_bucket_policy.lab_s3_bucket_policy
#   ]
# }
