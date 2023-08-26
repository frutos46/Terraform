resource "null_resource" "addfiles" {
  provisioner "file" {
    source = "Defaul.html"
    destination = "/var/www/html/Default.html"
    
    connection {
      type = "ssh"
      user = "adminuser"
      
    }
  }
}