resource "local_file" "fichero" {
    count = 5
    content = "Lista de productos en un ficheros"
    filename = "productos-${random_string.sufijo[count.index].id}.txt"
}


resource "random_string" "sufijo" {
  count = 5
  length = 4
  special=false
  upper = false
  numeric = false
  }


