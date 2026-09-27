terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "safedeploy" {
  name     = "rg-safedeploy-ai"
  location = "indiasouthcentral"
}

resource "azurerm_container_registry" "safedeploy" {
  name                = "safedeployaiacr"
  resource_group_name = azurerm_resource_group.safedeploy.name
  location            = azurerm_resource_group.safedeploy.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.safedeploy.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.safedeploy.id
  skip_service_principal_aad_check = true
}

resource "azurerm_kubernetes_cluster" "safedeploy" {
  name                = "aks-safedeploy-ai"
  location            = azurerm_resource_group.safedeploy.location
  resource_group_name = azurerm_resource_group.safedeploy.name
  dns_prefix          = "safedeploy-ai"

  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_B2s"

    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }
}