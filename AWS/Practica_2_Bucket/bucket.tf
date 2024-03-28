resource "aws_s3_bucket" "example" {
  count  = 5
  bucket = "bucket-${random_string.sufijo[count.index].id}"

  tags = {
    Name        = "My bucket-${random_string.sufijo[count.index].id}"
    Environment = "Dev"
  }
}

resource "random_string" "sufijo" {
  count   = 5
  length  = 4
  special = false
  upper   = false
  numeric = false
}
