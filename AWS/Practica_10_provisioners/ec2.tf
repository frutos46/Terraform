resource "aws_instance" "public_instance" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data = file("userdata.sh")

  /*lifecycle {
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
      ]

  }

  ## con esto podemos ejecutar codigo de manera local (local-exec) en nuestra propia maquina
  ## o de forma remota en la instancia donde nos situemos
 /* provisioner "local-exec" {
    command = "echo instancia creada con ip ${aws_instance.public_instance.public_ip} >> datos_instancia.txt"
  }

  provisioner "local-exec" {
    when = destroy ## indicamos que se ejecute cuando se destruya la instancia (por defecto es cuando se crea)
    ## cuando usamos destroy tenemos solo 3 opciones para llamar a los recursos
    # self
    # count.index
    # each.key


    command = "echo instancia creada con ip ${self.public_ip} >> datos_instancia.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'hola mundo > ~/saludo.txt"
    ]
    connection {
      type        = "SSH"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("mykey.pem")
    }
  }*/

}




