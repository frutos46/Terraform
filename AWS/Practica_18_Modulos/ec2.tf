variable "instancias" {
  description = "nombre de las instancias"
  type        = set(string)
  default     = ["apache", "mysql", "jumpserver"]
}
resource "aws_instance" "public_instance" {
  for_each               = var.instancias
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]

  tags = {
    Name = each.value
  }
}
resource "aws_instance" "monitoring" {
  #count                  = var.enable ? 1 : 0 # La ? es el if, si var.enable devuelve true count=1 sino count=0
  count                  = var.enable == 1 ? 1 : 0 ## para valores numericos
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]

  tags = {
    Name = "Monitoring"
  }
}