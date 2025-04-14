###########################################################################
#   Create WAS S3 Bucket And Upload Objects to it Using Terraform
###########################################################################

# Task 1: Create S3 Bucket
resource "aws_s3_bucket" "s3-bucket" {
  bucket = "wisdom.com00"
  tags   = { Name = "My Bucket" }
}

# Task 2: Uploads Objects To The Bucket


resource "aws_s3_bucket_object" "object" {
  bucket     = aws_s3_bucket.s3-bucket.id # Here is the id of the bucket above
  key        = "index.html"               # Key is the name of the file you want to upload
  source     = "C:/Users/Wisdom/Desktop/web/index.html"
  force_destroy = true
  depends_on = [aws_s3_bucket.s3-bucket]
}
 
 resource "aws_s3_bucket_versioning" "versioning" {
  bucket     = aws_s3_bucket.s3-bucket.id
  versioning_configuration {
  status = "enabled"
}
 }

 resource "aws_s3_bucket_server_side_encryption_configuration" "server-side" {
  bucket     = aws_s3_bucket.s3-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
 }