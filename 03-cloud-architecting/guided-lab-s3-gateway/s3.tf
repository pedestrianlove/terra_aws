resource "aws_s3_bucket" "lab_bucket_east_2" {
  provider = aws.east
}
resource "aws_s3_bucket_versioning" "lab_bucket_versioning_east_2" {
  provider = aws.east
  bucket   = aws_s3_bucket.lab_bucket_east_2.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "lab_bucket_west_2" {
  provider = aws.west
}
resource "aws_s3_bucket_versioning" "lab_bucket_versioning_west_2" {
  provider = aws.west
  bucket   = aws_s3_bucket.lab_bucket_west_2.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Replication rule
resource "aws_s3_bucket_replication_configuration" "lab_replication_rule" {
  provider = aws.east
  # Must have bucket versioning enabled first
  depends_on = [
    aws_s3_bucket_versioning.lab_bucket_versioning_east_2,
    aws_s3_bucket_versioning.lab_bucket_versioning_west_2
  ]

  role   = data.aws_iam_role.s3_crr_role.arn
  bucket = aws_s3_bucket.lab_bucket_east_2.id

  rule {
    id = "crr-full-bucket"

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.lab_bucket_west_2.arn
      storage_class = "STANDARD"
    }
  }
}
