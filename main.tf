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
