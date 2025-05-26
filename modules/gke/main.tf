resource "google_service_account" "gke_nodes_sa" {
  account_id   = "${var.environment}-gke-nodes-sa"
  display_name = "GKE Nodes Service Account"
}

resource "google_project_iam_member" "gke_nodes_sa_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/artifactregistry.reader",
    "roles/container.nodeServiceAccount"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_nodes_sa.email}"
}

resource "google_container_cluster" "private_gke_cluster" {
  name                     = "${var.environment}-private-gke-cluster"
  location                 = var.region
  deletion_protection      = false
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network_name
  subnetwork = var.subnet_name

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"

    master_global_access_config {
      enabled = true
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.management_subnet_cidr
      display_name = "Management Subnet"
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  binary_authorization {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  network_policy {
    enabled = true
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
    network_policy_config {
      disabled = false
    }
  }

  maintenance_policy {
    recurring_window {
      start_time = "2024-01-01T02:00:00Z"
      end_time   = "2024-01-01T06:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SA"
    }
  }

  depends_on = [google_project_iam_member.gke_nodes_sa_roles]
}

resource "google_container_node_pool" "private_nodes" {
  name       = "${var.environment}-private-node-pool"
  location   = var.region
  cluster    = google_container_cluster.private_gke_cluster.name
  node_count = 2

  node_config {
    preemptible  = false
    machine_type = "e2-medium"
    disk_size_gb = 50
    disk_type    = "pd-ssd"

    service_account = google_service_account.gke_nodes_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    tags = ["gke-node", "private-node"]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
