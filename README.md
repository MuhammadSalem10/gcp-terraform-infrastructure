```markdown
# GCP Terraform Infrastructure

A modular Terraform configuration for deploying secure GCP infrastructure with private GKE cluster, VPC networking, and load balancing.

## Architecture

- **VPC Network** with two subnets (management and restricted)
- **Private GKE Cluster** with custom service account
- **Management VM** for cluster access
- **Artifact Registry** for Docker images
- **Load Balancer** for public application exposure
- **Comprehensive Security** with firewall rules and network policies

## Quick Start

1. **Clone and Configure**
   ```bash
   git clone <repository-url>
   cd gcp-terraform-infrastructure
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

2. **Deploy Infrastructure**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Build and Push Docker Image**
   ```bash
   chmod +x scripts/build-and-push.sh
   ./scripts/build-and-push.sh
   ```

4. **Deploy Application**
   ```bash
   # SSH into management VM
   gcloud compute ssh dev-management-vm --zone=us-central1-a --tunnel-through-iap
   
   # Run deployment script
   chmod +x scripts/deploy-app.sh
   ./scripts/deploy-app.sh
   ```

## Customization

Update `variables.tf` or create `terraform.tfvars`:

```hcl
project_id   = "your-project-id"
region       = "us-central1"
environment  = "prod"
domain_name  = "your-domain.com"
```

## Security Features

- Private GKE cluster with no public endpoints
- Custom service accounts with minimal permissions
- Network segmentation with firewall rules
- Binary authorization for container images
- Workload Identity for pod authentication

## Module Structure

- `networking/` - VPC, subnets, NAT, firewall rules
- `compute/` - Management VM with tools
- `gke/` - Private GKE cluster and node pools
- `artifact-registry/` - Docker image repository
- `load-balancer/` - HTTP(S) load balancer

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - see LICENSE file for details