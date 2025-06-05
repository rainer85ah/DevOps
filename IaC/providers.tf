terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws   = { source = "hashicorp/aws",   version = "~> 5.0" }
    google = { source = "hashicorp/google", version = "~> 5.0" }
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

# For Docker Swarm, you might use a provider like 'aws', 'google', or 'azurerm' depending on where you want your VMs.