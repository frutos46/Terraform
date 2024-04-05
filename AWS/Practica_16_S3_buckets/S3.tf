resource "aws_s3_bucket" "cerberus_bucket" {
    bucket = "Bucket-${local.s3-sufix}"
  
}

