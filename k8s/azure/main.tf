# Minimal AKS for Interview Prep
# Cost: ~$30/month (B2s) or ~$9/month (spot) + FREE control plane
# Can stop cluster when not in use: az aks stop --name <name> --resource-group <rg>

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  name_suffix  = var.name_suffix != "" ? var.name_suffix : random_string.suffix.result
  cluster_name = "${var.name_prefix}-${local.name_suffix}"
  tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "interview-prep"
  })
}

# Resource Group
resource "azurerm_resource_group" "aks" {
  name     = "rg-${local.cluster_name}"
  location = var.location
  tags     = local.tags
}

# AKS Cluster - Minimal Config
resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.cluster_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = local.cluster_name
  kubernetes_version  = var.kubernetes_version

  # Free tier control plane
  sku_tier = "Free"

  # SystemAssigned managed identity (no service principal needed)
  identity {
    type = "SystemAssigned"
  }

  # Single node pool - minimal cost
  default_node_pool {
    name                        = "default"
    vm_size                     = var.node_vm_size
    node_count                  = var.use_spot ? null : var.node_count
    min_count                   = var.use_spot ? var.node_count : null
    max_count                   = var.use_spot ? var.node_count + 1 : null
    enable_auto_scaling         = var.use_spot
    temporary_name_for_rotation = "temppool"

    # No zones for minimal setup (saves complexity)
    # zones = [] is implicit

    os_disk_size_gb = 30
    os_disk_type    = "Managed"
  }

  # Kubenet - simpler than Azure CNI, no extra IP planning
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  # Disable AAD for simplicity (use local admin)
  local_account_disabled = false

  # Optional: auto-upgrade for security patches
  automatic_channel_upgrade = var.auto_upgrade ? "patch" : "none"

  tags = local.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count, # If autoscaling enabled
    ]
  }
}

# Optional: Spot node pool for even cheaper workloads
resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  count = var.use_spot ? 1 : 0

  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.node_vm_size
  priority              = "Spot"
  eviction_policy       = "Delete"
  spot_max_price        = -1 # Pay up to on-demand price

  enable_auto_scaling = true
  min_count           = 0
  max_count           = 3

  os_disk_size_gb = 30

  node_labels = {
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }

  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]

  tags = local.tags
}

# Optional: Basic ACR for pushing custom images
resource "azurerm_container_registry" "acr" {
  count = var.create_acr ? 1 : 0

  name                = replace("acr${local.cluster_name}", "-", "")
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  sku                 = "Basic" # Cheapest tier
  admin_enabled       = false

  tags = local.tags
}

# Grant AKS pull access to ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  count = var.create_acr ? 1 : 0

  scope                = azurerm_container_registry.acr[0].id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
