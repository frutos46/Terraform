resource "aws_instance" "VM01" {

  ami           = "ami-0b8b5288592eca360"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet01.id

  tags = {
    Name = "VM01"
  }

}