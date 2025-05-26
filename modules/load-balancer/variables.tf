variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for SSL certificate"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "zone" {
  description = "The GCP zone"
  type        = string
}
