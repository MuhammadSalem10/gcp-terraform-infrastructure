resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "${var.environment}-docker-images"
  format        = "DOCKER"

  cleanup_policies {
    id     = "keep-recent-versions"
    action = "KEEP"

    most_recent_versions {
      keep_count = 10
    }
  }
}
