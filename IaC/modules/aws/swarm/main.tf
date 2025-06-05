# Provision VMs for Swarm managers and workers on AWS
variable "manager_count" { default = 1 }
variable "worker_count" { default = 2 }
variable "instance_type" { default = "t3.medium" }
variable "region" { default = "us-east-1" }
variable "ssh_key_name" { description = "EC2 SSH key pair name" }

provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "manager" {
  count         = var.manager_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.ssh_key_name
  tags = {
    Name = "swarm-manager-${count.index}"
  }
  # Add subnet_id, vpc_security_group_ids, etc.
}

resource "aws_instance" "worker" {
  count         = var.worker_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.ssh_key_name
  tags = {
    Name = "swarm-worker-${count.index}"
  }
}

resource "null_resource" "swarm_bootstrap" {
  depends_on = [aws_instance.manager, aws_instance.worker]

  provisioner "remote-exec" {
    connection {
      host        = aws_instance.manager[0].public_ip
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_path)
    }
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo docker swarm init --advertise-addr ${aws_instance.manager[0].private_ip}"
    ]
  }
}

output "manager_public_ip" {
  value = aws_instance.manager[0].public_ip
}