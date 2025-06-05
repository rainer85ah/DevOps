# Azure AKS minimal cluster module
resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-aks-rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.environment}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.environment}-aks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

output "kubeconfig" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}