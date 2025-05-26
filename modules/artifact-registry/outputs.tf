output "repository_url" {
  description = "URL of the Artifact Registry repository"
  value       = google_artifact_registry_repository.docker_repo.name
}

output "repository_id" {
  description = "ID of the Artifact Registry repository"
  value       = google_artifact_registry_repository.docker_repo.repository_id
}
