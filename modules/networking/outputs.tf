output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "elastic_ip" {
  value = aws_eip.nat.public_ip
}