resource "google_project_service" "required_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "servicenetworking.googleapis.com"
  ])

  project = var.project_id
  service = each.value

  disable_dependent_services = false
  disable_on_destroy         = false
}

module "networking" {
  source = "./modules/networking"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  depends_on = [google_project_service.required_apis]
}

module "compute" {
  source = "./modules/compute"

  project_id            = var.project_id
  region                = var.region
  zone                  = var.zone
  environment           = var.environment
  network_name          = module.networking.vpc_name
  subnet_name           = module.networking.management_subnet_name
  service_account_email = module.gke.service_account_email
}

module "gke" {
  source = "./modules/gke"

  project_id             = var.project_id
  region                 = var.region
  environment            = var.environment
  network_name           = module.networking.vpc_name
  subnet_name            = module.networking.restricted_subnet_name
  management_subnet_cidr = module.networking.management_subnet_cidr

  depends_on = [google_project_service.required_apis]
}

module "artifact_registry" {
  source = "./modules/artifact-registry"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  depends_on = [google_project_service.required_apis]
}

module "load_balancer" {
  source = "./modules/load-balancer"

  project_id   = var.project_id
  environment  = var.environment
  domain_name  = var.domain_name
  network_name = module.networking.vpc_name
  zone         = var.zone
}
