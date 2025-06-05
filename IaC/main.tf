module "eks" {
  source      = "./modules/aws-eks"
  region      = var.aws_region
  environment = var.environment
  # ...other variables
}

module "gke" {
  source      = "./modules/gcp-gke"
  project     = var.gcp_project
  region      = var.gcp_region
  environment = var.environment
  # ...other variables
}

module "aks" {
  source               = "./modules/azure-aks"
  subscription_id      = var.azure_subscription_id
  environment          = var.environment
  # ...other variables
}

module "aws_swarm" {
  source              = "./modules/aws/swarm"
  manager_count       = 1
  worker_count        = 2
  region              = var.aws_region
  ssh_key_name        = var.ssh_key_name
  ssh_private_key_path = var.ssh_private_key_path
}

module "gcp_swarm" {
  source              = "./modules/gcp/swarm"
  manager_count       = 1
  worker_count        = 2
  # ...other variables
}

module "azure_swarm" {
  source              = "./modules/azure/swarm"
  manager_count       = 1
  worker_count        = 2
  # ...other variables
}