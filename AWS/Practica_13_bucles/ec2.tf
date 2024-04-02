##Ejemplo con listas y count

/*variable "instancias" {
  description = "nombre instancias"
  type = list(string)
  default = [ "apache", "mysql", "jumpserver" ]
}

resource "aws_instance" "public_instance" {
  count = length(var.instancias)
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]

  tags = {
    Name = var.instancias[count.index]
  }
}
*/


# Ejemplo con foreach, solo funciona con set y maps

variable "instancias" {
  description = "nombre de las instancias"
  type        = set(string)
  default = [ "apache","mysql","jumpserver" ]
}

resource "aws_instance" "public_instance" {
  for_each               = var.instancias ## si esto fuera una lista podemos usar la funcion toSet() para convertirlo en un set
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]

  tags = {
    Name = each.value
  }
}