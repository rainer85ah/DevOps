variable "manager_count" { default = 1 }
variable "worker_count"  { default = 2 }
variable "machine_type"  { default = "e2-medium" }
variable "project"       { description = "GCP project ID" }
variable "region"        { default = "us-central1" }
variable "ssh_user"      { default = "ubuntu" }
variable "ssh_public_key"  { description = "SSH public key" }
variable "ssh_private_key" { description = "Path to SSH private key file" }

resource "google_compute_network" "swarm" {
  name = "swarm-net"
}

resource "google_compute_subnetwork" "swarm" {
  name          = "swarm-subnet"
  network       = google_compute_network.swarm.id
  ip_cidr_range = "10.10.0.0/16"
  region        = var.region
}

resource "google_compute_instance" "manager" {
  count        = var.manager_count
  name         = "swarm-manager-${count.index}"
  machine_type = var.machine_type
  zone         = "${var.region}-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.swarm.id
    access_config {}
  }
  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}

resource "google_compute_instance" "worker" {
  count        = var.worker_count
  name         = "swarm-worker-${count.index}"
  machine_type = var.machine_type
  zone         = "${var.region}-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.swarm.id
    access_config {}
  }
  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}

resource "null_resource" "swarm_bootstrap" {
  depends_on = [google_compute_instance.manager, google_compute_instance.worker]

  provisioner "remote-exec" {
    connection {
      host        = google_compute_instance.manager[0].network_interface[0].access_config[0].nat_ip
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
    }
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo docker swarm init --advertise-addr $(hostname -I | awk '{print $1}')"
    ]
  }
}

output "manager_public_ip" {
  value = google_compute_instance.manager[0].network_interface[0].access_config[0].nat_ip
}