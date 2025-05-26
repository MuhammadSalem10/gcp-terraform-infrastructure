resource "google_compute_global_address" "lb_ip" {
  name         = "${var.environment}-demo-app-lb-ip"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

resource "google_compute_managed_ssl_certificate" "lb_ssl_cert" {
  name = "${var.environment}-demo-app-ssl-cert"

  managed {
    domains = [var.domain_name]
  }
}

resource "google_compute_health_check" "demo_app_health_check" {
  name               = "${var.environment}-demo-app-health-check"
  timeout_sec        = 5
  check_interval_sec = 10

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

resource "google_compute_instance_group" "gke_ig" {
  name = "${var.environment}-gke-instance-group"
  zone = var.zone

  named_port {
    name = "http"
    port = "80"
  }
}

resource "google_compute_backend_service" "demo_app_backend" {
  name                  = "${var.environment}-demo-app-backend"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_instance_group.gke_ig.id
  }

  health_checks = [google_compute_health_check.demo_app_health_check.id]

  log_config {
    enable = true
  }
}

resource "google_compute_url_map" "demo_app_url_map" {
  name            = "${var.environment}-demo-app-url-map"
  default_service = google_compute_backend_service.demo_app_backend.id
}

resource "google_compute_target_https_proxy" "demo_app_https_proxy" {
  name             = "${var.environment}-demo-app-https-proxy"
  url_map          = google_compute_url_map.demo_app_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.lb_ssl_cert.id]
}

resource "google_compute_global_forwarding_rule" "demo_app_forwarding_rule" {
  name                  = "${var.environment}-demo-app-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.demo_app_https_proxy.id
  ip_address            = google_compute_global_address.lb_ip.id
}
