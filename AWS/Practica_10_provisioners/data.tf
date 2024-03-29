## con la estructura data podemos leer recursos que ya existen

data "aws_key_pair" "key" {
  key_name = "mykey"
}