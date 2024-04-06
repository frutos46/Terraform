resource "aws_instance" "server1" {
  ami                    = "ami-0c1c30571d2dae5c9"
  subnet_id              = data.aws_subnet.AZ_a.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mi_grupo_seguridad.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hola Terraformers soy server 1!" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    Name = "mi-servidor-1"
  }
}
resource "aws_instance" "server2" {
  ami                    = "ami-0c1c30571d2dae5c9"
  subnet_id              = data.aws_subnet.AZ_b.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.mi_grupo_seguridad.id]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hola Terraformers soy server 2!" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    Name = "mi-servidor-2"
  }
}



resource "aws_security_group" "mi_grupo_seguridad" {
  name = "primer-servidor-sg"

  dynamic "ingress" {
    for_each = var.ingress_port_list
    content {
      security_groups = [aws_security_group.mi_grupo_seguridad_elb.id]
      from_port   = ingress.value
      description = "Acceso desde el exterior desde el puerto 8080"
      to_port     = ingress.value
      protocol    = "TCP"
      #cidr_blocks = ["0.0.0.0/0"]

    }
  }

}


resource "aws_lb" "ELB" {
  load_balancer_type = "application"
  name               = "terraformers-alb"
  security_groups    = [aws_security_group.mi_grupo_seguridad_elb.id]
  subnets            = [data.aws_subnet.AZ_a.id, data.aws_subnet.AZ_b.id]

}

resource "aws_security_group" "mi_grupo_seguridad_elb" {
  name = "primer-lb-sg"

  dynamic "ingress" {
    for_each = var.ingress_port_list_lb
    content {
      from_port   = ingress.value
      description = "Acceso desde el exterior desde el puerto 8080"
      to_port     = ingress.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.ingress_port_list
    content {
      from_port   = 80
      description = "Acceso desde el exterior desde el puerto 8080"
      to_port     = 80
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

}


resource "aws_lb_target_group" "this" {
  name     = "terraformers-alb-target-group"
  port     = 80
  vpc_id   = data.aws_vpc.vpc.id
  protocol = "HTTP"
  health_check {
    enabled  = true
    matcher  = 200
    path     = "/"
    port     = "8080"
    protocol = "HTTP"
  }
}


resource "aws_lb_target_group_attachment" "attachment_server1" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.server1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "attachment_server2" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.server2.id
  port             = 8080
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.ELB.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }
} 