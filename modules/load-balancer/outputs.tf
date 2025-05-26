output "external_ip" {
  description = "External IP address of the load balancer"
  value       = google_compute_global_address.lb_ip.address
}

output "ssl_certificate_name" {
  description = "Name of the SSL certificate"
  value       = google_compute_managed_ssl_certificate.lb_ssl_cert.name
}
