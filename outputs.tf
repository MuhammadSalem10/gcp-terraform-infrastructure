output "vpc_name" {
  description = "Name of the VPC"
  value       = module.networking.vpc_name
}

output "gke_cluster_name" {
  description = "Name of the GKE cluster"
  value       = module.gke.cluster_name
}

output "gke_cluster_endpoint" {
  description = "Endpoint of the GKE cluster"
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

output "artifact_registry_url" {
  description = "URL of the Artifact Registry repository"
  value       = module.artifact_registry.repository_url
}

output "management_vm_internal_ip" {
  description = "Internal IP address of management VM"
  value       = module.compute.vm_internal_ip
}

output "load_balancer_ip" {
  description = "Static IP address of the load balancer"
  value       = module.load_balancer.external_ip
}

output "service_account_email" {
  description = "Email of the custom service account"
  value       = module.gke.service_account_email
}
