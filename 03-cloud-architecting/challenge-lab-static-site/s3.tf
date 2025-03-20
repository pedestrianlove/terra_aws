resource "aws_s3_bucket" "lab_s3_bucket" {
  bucket_prefix = "htmlbuckettestingisnotfunbruh"
}
resource "aws_s3_bucket_website_configuration" "lab_s3_static_website_config" {
  bucket = aws_s3_bucket.lab_s3_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "lab_s3_versioning" {
  bucket = aws_s3_bucket.lab_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "lab_s3_lifecycle" {
  bucket = aws_s3_bucket.lab_s3_bucket.id

  rule {
    id = "rule-1"

    filter {
      prefix = ""
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    status = "Enabled"
  }

  rule {
    id = "rule-2"

    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = 365
    }

    status = "Enabled"
  }
}
