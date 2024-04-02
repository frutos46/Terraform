resource "aws_instance" "public_instance" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]

  lifecycle {
    ## con este comando indicamos a terraform que si hay que recrear la maquina primero la crea y luego la destruye
    #create_before_destroy = true

    ## con este comando indicamos que no se puede destruir la maquina
    #prevent_destroy = true

    ## con este comando ignoramos los cambios que se indican en la lista
    /*ignore_changes = [ 
      ami,
      subnet_id
     ]*/

    ## añadimos una lista de recursos que si sufren algun cambio se recreara la maquina
    /* replace_triggered_by = [ 
      aws_subnet.private_subnet
      ]*/

  }

}



