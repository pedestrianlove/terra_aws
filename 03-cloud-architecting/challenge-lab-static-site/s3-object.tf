resource "aws_s3_object" "lab_s3_website" {
  for_each = fileset("./static-website/", "**")

  key    = each.value
  bucket = aws_s3_bucket.lab_s3_bucket.id
  source = "./static-website/${each.value}"
  etag   = filemd5("./static-website/${each.value}")

  # Upload files after every thing is setup
  depends_on = [
    aws_s3_bucket_ownership_controls.lab_s3_ownership,
    aws_s3_bucket_website_configuration.lab_s3_static_website_config,
    aws_s3_bucket_public_access_block.lab_s3_public_access,
    aws_s3_bucket_versioning.lab_s3_versioning,
    aws_s3_bucket_lifecycle_configuration.lab_s3_lifecycle
  ]
}


