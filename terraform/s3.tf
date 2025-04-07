resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "ror_s3" {
  bucket        = "ror-app-bucket-${random_id.bucket_id.hex}"
  force_destroy = true

  tags = {
    Name = "ror-app-bucket"
  }
}
