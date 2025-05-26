output "cluster_name" {
  value = google_container_cluster.private_gke_cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint of the GKE cluster"
  value       = google_container_cluster.private_gke_cluster.endpoint
  sensitive   = true
}

output "service_account_email" {
  description = "Email of the custom service account"
  value       = google_service_account.gke_nodes_sa.email
}
