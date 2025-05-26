resource "google_compute_instance" "management_vm" {
  name         = "${var.environment}-management-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name
  }

  service_account {
    email = var.service_account_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  metadata_startup_script = file("${path.module}/startup-script.sh")

  metadata = {
    enable-oslogin = "TRUE"
  }

  tags = ["management-vm", "private-vm"]
}
