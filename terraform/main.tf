#terraform/main.tf

provider "aws" {
  region = var.aws_region
}

# 1. Networking
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "portfolio-vpc" }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zone   # Now a variable
  map_public_ip_on_launch = true
  tags = { Name = "portfolio-subnet" }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "portfolio-igw" }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = { Name = "portfolio-rt" }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# 2. Security Group
resource "aws_security_group" "k3s" {
  name        = "k3s-sg"
  description = "Allow K3s traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "k3s-sg" }
}

# 3. EC2 Instance (Free Tier) – using hardcoded AMI ID
resource "aws_instance" "k3s_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.k3s.id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Install K3s
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --bind-address 0.0.0.0 --tls-san $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)" sh -

    # Wait for cluster to be ready
    for i in {1..60}; do
      if kubectl get nodes >/dev/null 2>&1; then
        break
      fi
      echo "Waiting for K3s to be ready... (attempt $i)"
      sleep 5
    done

    # Copy kubeconfig to a readable location
    sudo cp /etc/rancher/k3s/k3s.yaml /tmp/kubeconfig
    sudo chmod 644 /tmp/kubeconfig

    # Replace localhost with public IP
    PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
    sed -i "s/127.0.0.1/$PUBLIC_IP/g" /tmp/kubeconfig
    EOF

  tags = { Name = "k3s-server" }
}

# 4. Fetch kubeconfig via SSH
resource "null_resource" "fetch_kubeconfig" {
  depends_on = [aws_instance.k3s_server]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = aws_instance.k3s_server.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      # Wait for k3s config to exist
      "for i in $(seq 1 30); do if sudo test -f /etc/rancher/k3s/k3s.yaml; then break; fi; echo 'Waiting for k3s...'; sleep 5; done",
      # Get public IP
      "PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)",
      # Generate kubeconfig with correct IP (use | as delimiter to avoid conflict with /)
      "sudo sed 's|127.0.0.1|'$PUBLIC_IP'|g' /etc/rancher/k3s/k3s.yaml | sudo tee /tmp/kubeconfig >/dev/null",
      "sudo chmod 644 /tmp/kubeconfig"
    ]
  }

  # Copy the file from remote to local using scp (local-exec runs on the Terraform host)
  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.private_key_path} ubuntu@${aws_instance.k3s_server.public_ip}:/tmp/kubeconfig ${path.module}/../kubeconfig"
  }
}