provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
}

module "networking" {
  source = "./modules/networking"

  vpc_id             = module.vpc.vpc_id
  public_subnet_cidr = var.public_subnet_cidr
  environment        = var.environment
}

module "ec2" {
  source = "./modules/ec2"

  subnet_id     = module.networking.public_subnet_id
  instance_type = var.instance_type
  ami_id        = var.ami_id
  environment   = var.environment
  domain_name   = var.domain_name
  git_repo_url  = var.git_repo_url
  git_branch    = var.git_branch
  github_token  = var.github_token
}

module "s3" {
  source = "./modules/s3"

  bucket_name       = var.bucket_name
  environment      = var.environment
  bucket_versioning = var.bucket_versioning
}