resource "google_compute_network" "main_vpc" {
  name                    = "${var.environment}-vpc-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "management_subnet" {
  name          = "${var.environment}-management-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.main_vpc.id

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "management-secondary"
    ip_cidr_range = "10.1.0.0/16"
  }
}

resource "google_compute_subnetwork" "restricted_subnet" {
  name          = "${var.environment}-restricted-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  network       = google_compute_network.main_vpc.id

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = "10.2.0.0/16"
  }

  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = "10.3.0.0/16"
  }
}

resource "google_compute_router" "management_router" {
  name    = "${var.environment}-management-router"
  region  = var.region
  network = google_compute_network.main_vpc.id
}

resource "google_compute_router_nat" "management_nat" {
  name   = "${var.environment}-management-nat-gateway"
  router = google_compute_router.management_router.name
  region = var.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.management_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_firewall" "allow_management_to_gke" {
  name    = "${var.environment}-allow-management-to-gke"
  network = google_compute_network.main_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["443", "10250"]
  }

  source_ranges = [google_compute_subnetwork.management_subnet.ip_cidr_range]
  target_tags   = ["gke-node"]
}

resource "google_compute_firewall" "allow_health_checks" {
  name    = "${var.environment}-allow-health-checks"
  network = google_compute_network.main_vpc.name

  allow {
    protocol = "tcp"
  }

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]

  target_tags = ["gke-node"]
}

resource "google_compute_firewall" "allow_internal" {
  name    = "${var.environment}-allow-internal-vpc"
  network = google_compute_network.main_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    google_compute_subnetwork.management_subnet.ip_cidr_range,
    google_compute_subnetwork.restricted_subnet.ip_cidr_range,
    "10.2.0.0/16",
    "10.3.0.0/16"
  ]
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "${var.environment}-allow-iap-ssh"
  network = google_compute_network.main_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["management-vm"]
}
