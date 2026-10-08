variable "name_prefix" {
  type        = string
  default     = "aks-demo"
  description = "Prefix for resource names"
}

variable "name_suffix" {
  type        = string
  default     = ""
  description = "Suffix for resource names (random if empty)"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region. eastus is usually cheapest."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment tag"
}

variable "kubernetes_version" {
  type        = string
  default     = null
  description = "Kubernetes version; null uses the AKS default. 'az aks get-versions -l <location>' lists the supported ones."
}

variable "node_vm_size" {
  type        = string
  default     = "Standard_B2s"
  description = "VM size for nodes. B2s is cheapest (~$30/month). Options: Standard_B2s, Standard_B2ms, Standard_D2s_v3"
}

variable "node_count" {
  type        = number
  default     = 1
  description = "Number of nodes (keep at 1 for minimal cost)"
}

variable "use_spot" {
  type        = bool
  default     = false
  description = "Use spot instances for ~70% cost savings (can be evicted)"
}

variable "auto_upgrade" {
  type        = bool
  default     = true
  description = "Enable automatic patch upgrades"
}

variable "create_acr" {
  type        = bool
  default     = false
  description = "Create Azure Container Registry (Basic SKU adds ~$5/month)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for resources"
}
