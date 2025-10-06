resource "google_storage_bucket" "bucket" {
  project                     = var.project_id
  name                        = var.name
  location                    = var.location
  storage_class               = var.storage_class
  uniform_bucket_level_access = var.uniform_bucket_level_access
  force_destroy               = var.force_destroy
  labels                      = var.labels

  dynamic "versioning" {
    for_each = var.versioning ? [1] : []
    content {
      enabled = true
    }
  }
}