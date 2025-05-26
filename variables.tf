variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "extra-project-460210"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "domain_name" {
  description = "Domain name for SSL certificate"
  type        = string
  default     = "example.com"
}
