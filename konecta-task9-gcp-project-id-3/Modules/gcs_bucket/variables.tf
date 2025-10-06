variable "project_id" {
  description = "Target GCP project ID"
  type        = string
}

variable "name" {
  description = "Bucket name"
  type        = string
}

variable "location" {
  description = "Bucket location"
  type        = string
}

variable "storage_class" {
  description = "Bucket storage class"
  type        = string
  default     = "STANDARD"
}

variable "uniform_bucket_level_access" {
  description = "Enable uniform bucket-level access"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow destroying bucket with objects"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels for the bucket"
  type        = map(string)
  default     = {}
}

variable "versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}
