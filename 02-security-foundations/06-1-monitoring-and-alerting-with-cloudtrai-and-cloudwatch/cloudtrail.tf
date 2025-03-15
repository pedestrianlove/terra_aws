# resource "aws_s3_bucket" "lab_cloudtrail_bucket" {
#   bucket        = "aws-cloudtrail-logs"
#   force_destroy = true
# }
#
# resource "aws_cloudtrail" "lab_cloudtrail" {
#   name = "MyLabCloudTrail"
#
#   s3_bucket_name = aws_s3_bucket.lab_cloudtrail_bucket.id
#   enable_logging = true
#
#   event_selector {
#     read_write_type           = "All"
#     include_management_events = true
#
#     data_resource {
#
#     }
#   }
#
#   tags = {
#     Name = "MyLabCloudTrail"
#   }
# }
