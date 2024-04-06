output "dns_public1" {
  description = "URL del servidor web"
  value       = "http://${aws_instance.server1.public_dns}:8080"
}

output "dns_public2" {
  description = "URL del servidor web"
  value       = "http://${aws_instance.server2.public_dns}:8080"
}

output "dns_lb" {
  description = "URL del servidor web"
  value       = "http://${aws_lb.ELB.dns_name}"
}