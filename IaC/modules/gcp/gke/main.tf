# GCP GKE minimal cluster module
resource "google_compute_network" "vpc" {
  name = "${var.environment}-gke-vpc"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.environment}-gke-subnet"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
}

module "gke" {
  source     = "terraform-google-modules/kubernetes-engine/google"
  version    = "~> 30.0"
  project_id = var.project
  name       = "${var.environment}-gke"
  region     = var.region
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  node_pools = [
    {
      name         = "default-pool"
      machine_type = "e2-medium"
      min_count    = 1
      max_count    = 3
      initial_node_count = 2
      auto_upgrade = true
    }
  ]
}

output "kubeconfig" {
  value = module.gke.kubeconfig_raw
  sensitive = true
}