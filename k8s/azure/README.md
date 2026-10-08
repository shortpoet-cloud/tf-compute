# Minimal AKS for Interview Prep

Cost-optimized AKS cluster for demonstrating Kubernetes knowledge.

## Cost Estimate

| Resource | Monthly Cost |
|----------|--------------|
| AKS Control Plane | FREE (Free tier) |
| 1x B2s Node | ~$30 |
| 1x B2s Spot Node | ~$9 (70% discount) |
| Basic ACR (optional) | ~$5 |

**Tip**: Stop the cluster when not in use to avoid node costs.

## Quick Start

```bash
# 1. Login to Azure
az login
az account set --subscription "<your-subscription>"

# 2. Initialize and apply
cd tf-compute/k8s/azure
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars as needed

terraform init
terraform plan
terraform apply

# 3. Get kubeconfig
$(terraform output -raw get_credentials_command)

# 4. Verify
kubectl get nodes
kubectl get pods -A
```

## Cost Management

```bash
# Stop cluster when not in use (saves node costs)
$(terraform output -raw stop_cluster_command)

# Start cluster when needed
$(terraform output -raw start_cluster_command)

# Check cluster status
az aks show --resource-group <rg> --name <name> --query powerState
```

## Deploy Demo App

```bash
# Create demo namespace
kubectl create namespace demo

# Deploy nginx
kubectl create deployment nginx --image=nginx --namespace=demo
kubectl expose deployment nginx --port=80 --namespace=demo
kubectl get all -n demo

# Test with port-forward
kubectl port-forward svc/nginx -n demo 8080:80
# Visit http://localhost:8080
```

## Interview Talking Points

1. **"Why kubenet vs Azure CNI?"**
   > For this demo, kubenet is simpler—pods get IPs from an overlay network. Azure CNI is better for production when pods need direct VNet access, but requires more IP planning.

2. **"Why SystemAssigned identity?"**
   > Managed identities eliminate credential management. SystemAssigned is simpler for the cluster itself. For workloads accessing Azure resources, I'd use Workload Identity with UserAssigned identities.

3. **"How would you make this production-ready?"**
   > Add: Azure CNI, multiple node pools (system + workload), availability zones, AAD RBAC, Log Analytics, Key Vault CSI driver, network policies (Calico), and move to Standard tier for SLA.

## Clean Up

```bash
# Destroy all resources
terraform destroy

# Or just stop (keeps config, stops billing for nodes)
$(terraform output -raw stop_cluster_command)
```

## Upgrade Path to Production

See `_docs/plans/k8s-interview-prep/02-ENTERPRISE-AKS-TERRAFORM.md` for full enterprise patterns including:
- Azure CNI with network policies
- AAD integration
- Multiple node pools
- Key Vault integration
- CI/CD pipeline
