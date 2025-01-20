#!/bin/bash
set -e

# Update system
sudo apt-get update
sudo apt-get upgrade -y

# Install required packages
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    git \
    nginx \
    certbot \
    python3-certbot-nginx

# Configure git to use PAT
sudo -u ubuntu git config --global credential.helper store
echo "https://${github_token}@github.com" > /home/ubuntu/.git-credentials
sudo chown ubuntu:ubuntu /home/ubuntu/.git-credentials
sudo chmod 600 /home/ubuntu/.git-credentials

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Clone repository
# Set environment variable for Git
export GIT_ASKPASS=/bin/true
# sudo -u ubuntu GIT_ASKPASS=/bin/true git clone ${git_repo_url} --branch ${git_branch} /home/ubuntu/app
sudo -u ubuntu git clone https://${github_token}@github.com/${git_repo_url} /home/ubuntu/app

cd /home/ubuntu/app

# Start Docker Compose in detached mode
sudo -u ubuntu docker-compose up -d

# Configure Nginx
cat > /etc/nginx/sites-available/default << 'EOF'
server {
    listen 80;
    server_name ${domain_name};

    location / {
        proxy_pass http://localhost:8080;  # Adjust port according to your docker-compose.yml
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Enable the site
sudo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Test Nginx configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx

# Get SSL certificate
sudo certbot --nginx -d ${domain_name} --non-interactive --agree-tos -m admin@${domain_name} --redirect