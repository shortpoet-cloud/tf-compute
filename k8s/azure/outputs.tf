output "resource_group_name" {
  value       = azurerm_resource_group.aks.name
  description = "Resource group name"
}

output "cluster_name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "AKS cluster name"
}

output "cluster_id" {
  value       = azurerm_kubernetes_cluster.aks.id
  description = "AKS cluster resource ID"
}

output "kube_config_raw" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
  description = "Raw kubeconfig for kubectl"
}

output "host" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].host
  sensitive   = true
  description = "Kubernetes API server URL"
}

output "cluster_identity_principal_id" {
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  description = "Cluster managed identity principal ID"
}

output "kubelet_identity_object_id" {
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  description = "Kubelet managed identity object ID (use for ACR, Key Vault access)"
}

output "node_resource_group" {
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
  description = "Resource group containing AKS nodes (MC_* group)"
}

output "acr_login_server" {
  value       = var.create_acr ? azurerm_container_registry.acr[0].login_server : null
  description = "ACR login server URL"
}

# Helper outputs for quick commands
output "get_credentials_command" {
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.aks.name} --name ${azurerm_kubernetes_cluster.aks.name}"
  description = "Command to get kubeconfig"
}

output "stop_cluster_command" {
  value       = "az aks stop --resource-group ${azurerm_resource_group.aks.name} --name ${azurerm_kubernetes_cluster.aks.name}"
  description = "Command to stop cluster (save costs when not in use)"
}

output "start_cluster_command" {
  value       = "az aks start --resource-group ${azurerm_resource_group.aks.name} --name ${azurerm_kubernetes_cluster.aks.name}"
  description = "Command to start cluster"
}
