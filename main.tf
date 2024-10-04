terraform {
  backend "remote" {
    organization = "alysia-tailscale"

    workspaces {
      name = "main"
    }
  }
}
provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "subnet_router" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "Tailscale Subnet Router"
  }

  user_data = <<-EOF
              #!/bin/bash
              curl -fsSL https://tailscale.com/install.sh | sh
              systemctl start tailscaled
              tailscale up --authkey=${var.auth_key}
              echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
              echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
              sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
              sudo tailscale up --advertise-routes=172.31.32.0/20
              EOF
}

resource "aws_instance" "tailscale_device" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "Tailscale Device"
  }

  user_data = <<-EOF
              #!/bin/bash
              curl -fsSL https://tailscale.com/install.sh | sh
              systemctl start tailscaled
              tailscale up --authkey=${var.auth_key}
              EOF
}
