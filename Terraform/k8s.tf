# Create AKS Cluster
resource "azurerm_kubernetes_cluster" "module5_aks" {
  name                = "module5_aks"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = "module5-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Kubernetes provider configuration
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.module5_aks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.module5_aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.module5_aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.module5_aks.kube_config.0.cluster_ca_certificate)
}

# Create Namespace in Kubernetes
resource "kubernetes_namespace" "jenkins" {
  depends_on = [azurerm_kubernetes_cluster.module5_aks]

  metadata {
    name = "jenkins"
    labels = {
      environment = "development"
    }
  }
}
