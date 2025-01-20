resource "aws_security_group" "instance" {
  name_prefix = "${var.environment}-instance-sg"
  description = "Security group for EC2 instance"
  vpc_id      = data.aws_subnet.selected.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-instance-sg"
    Environment = var.environment
  }
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [aws_security_group.instance.id]
  
  user_data = templatefile("${path.module}/user_data.sh", {
    domain_name  = var.domain_name
    git_repo_url = var.git_repo_url
    git_branch   = var.git_branch
    github_token = var.github_token
  })

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name        = "${var.environment}-instance"
    Environment = var.environment
  }
}