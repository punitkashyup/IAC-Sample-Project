output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.networking.public_subnet_id
}

output "elastic_ip" {
  value = module.networking.elastic_ip
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "instance_public_ip" {
  value = module.ec2.instance_public_ip
}

output "bucket_arn" {
  value = module.s3.bucket_arn
}