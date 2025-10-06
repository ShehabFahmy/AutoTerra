variable "project_id" {
  description = "Target GCP project ID"
  type        = string
}

variable "name" {
  description = "Instance name"
  type        = string
}

variable "machine_type" {
  description = "Machine type (e.g., e2-medium)"
  type        = string
}

variable "zone" {
  description = "Zone to deploy the instance in"
  type        = string
}

variable "image" {
  description = "Source image for boot disk"
  type        = string
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Boot disk type (pd-balanced, pd-ssd, etc.)"
  type        = string
  default     = "pd-balanced"
}

variable "network" {
  description = "VPC network self-link or name"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork self-link or name"
  type        = string
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Network tags for the instance"
  type        = list(string)
  default     = []
}

variable "metadata" {
  description = "Metadata key/value pairs"
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Labels for the instance"
  type        = map(string)
  default     = {}
}
