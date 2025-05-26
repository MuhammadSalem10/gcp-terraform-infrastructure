output "vpc_name" {
  description = "Name of the VPC"
  value       = google_compute_network.main_vpc.name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = google_compute_network.main_vpc.id
}

output "management_subnet_name" {
  description = "Name of the management subnet"
  value       = google_compute_subnetwork.management_subnet.name
}

output "management_subnet_cidr" {
  description = "CIDR range of management subnet"
  value       = google_compute_subnetwork.management_subnet.ip_cidr_range
}

output "restricted_subnet_name" {
  description = "Name of the restricted subnet"
  value       = google_compute_subnetwork.restricted_subnet.name
}

output "restricted_subnet_cidr" {
  description = "CIDR range of restricted subnet"
  value       = google_compute_subnetwork.restricted_subnet.ip_cidr_range
}
