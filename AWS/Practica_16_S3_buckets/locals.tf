locals {
  sufix = "-cerberus-pro"
}

resource "random_string" "sufijo-s3" {
    length = 8
    special = false
    upper = false
  
}

locals {
  s3-sufix="Bucket-${local.sufix}-${random_string.sufijo-s3.id}"
}