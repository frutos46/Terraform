


## importamos un recurso creado en aws


#1 creamos el recurso
#2 importamos el recurso de aws: terraform import aws_instance.mywebserver i-0c7056f6105d02449 (id de la ec2 que se creo en aws)
## no se rellena el contenido, se queda en el tfstate.
#3 Para ver el codigo del recurso y poder copiar en él se hace terraform state list, obtenemos el recursos y luego terraform state show <name recurso>
#4 despues adaptamos y terraform plan
resource "aws_instance" "mywebserver" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  key_name      = data.aws_key_pair.key.key_name
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    "Name" = "MyServer"
  }
  vpc_security_group_ids = [
    aws_security_group.sg_public_instance.id,
  ]


}