module "project" {
  source          = "./Modules/project"
  project_name    = var.project.project_name
  project_id      = var.project.project_id
  organization_id = var.project.organization_id
  billing_account = var.project.billing_account
  deletion_policy = var.project.deletion_policy
  labels          = var.project.labels
  apis            = var.project.apis
}

module "vpc" {
  source     = "./Modules/vpc"
  name       = var.vpc_name
  project_id = module.project.project_id
}

module "routes" {
  source        = "./Modules/route"
  count         = length(var.routes)
  project_id    = module.project.project_id
  vpc_self_link = module.vpc.vpc_self_link
  name          = var.routes[count.index].name
  dest_range    = var.routes[count.index].dest_range
  next_hop_gateway  = var.routes[count.index].next_hop_gateway
  next_hop_ip       = var.routes[count.index].next_hop_ip
  next_hop_instance = var.routes[count.index].next_hop_instance
  next_hop_ilb      = var.routes[count.index].next_hop_ilb
  priority          = var.routes[count.index].priority
  tags              = var.routes[count.index].tags
}

module "subnets" {
  source        = "./Modules/subnet"
  count         = length(var.subnets)
  name          = var.subnets[count.index].name
  cidr          = var.subnets[count.index].cidr
  region        = var.subnets[count.index].region
  vpc_self_link = module.vpc.vpc_self_link
  project_id    = module.project.project_id
}

module "firewall_rules" {
  source        = "./Modules/firewall_rule"
  count         = length(var.firewall_rules)
  name          = var.firewall_rules[count.index].name
  vpc_self_link = module.vpc.vpc_self_link
  project_id    = module.project.project_id
  protocol      = var.firewall_rules[count.index].protocol
  ports         = var.firewall_rules[count.index].ports
  source_ranges = var.firewall_rules[count.index].source_ranges
}

module "compute_disks" {
  source            = "./Modules/compute_disk"
  count             = length(var.compute_disks)
  project_id        = module.project.project_id
  name              = var.compute_disks[count.index].name
  zone              = var.compute_disks[count.index].zone
  size_gb           = var.compute_disks[count.index].size_gb
  type              = var.compute_disks[count.index].type
  image             = var.compute_disks[count.index].image
  snapshot          = var.compute_disks[count.index].snapshot
  labels            = var.compute_disks[count.index].labels
  kms_key_self_link = var.compute_disks[count.index].kms_key_self_link
}

module "static_ips" {
  source       = "./Modules/static_ip"
  count        = length(var.static_ips)
  project_id   = module.project.project_id
  name         = var.static_ips[count.index].name
  address_type = var.static_ips[count.index].address_type
  region       = var.static_ips[count.index].region
  network_tier = var.static_ips[count.index].network_tier
  subnetwork   = var.static_ips[count.index].subnetwork
  purpose      = var.static_ips[count.index].purpose
  address      = var.static_ips[count.index].address
  description  = var.static_ips[count.index].description
}

module "service_accounts" {
  source       = "./Modules/service_account"
  count        = length(var.service_accounts)
  project_id   = module.project.project_id
  account_id   = var.service_accounts[count.index].account_id
  display_name = var.service_accounts[count.index].display_name
  description  = var.service_accounts[count.index].description
}

module "cloud_dns" {
  source      = "./Modules/cloud_dns"
  count       = length(var.cloud_dns_zones)
  project_id  = module.project.project_id
  name        = var.cloud_dns_zones[count.index].name
  dns_name    = var.cloud_dns_zones[count.index].dns_name
  description = var.cloud_dns_zones[count.index].description
  record_sets = var.cloud_dns_zones[count.index].record_sets
}

module "gcs_bucket" {
  source = "./Modules/gcs_bucket"

  project_id = module.project.project_id
  name       = var.gcs_bucket.name
  location   = var.gcs_bucket.location

  storage_class               = var.gcs_bucket.storage_class
  uniform_bucket_level_access = var.gcs_bucket.uniform_bucket_level_access
  force_destroy               = var.gcs_bucket.force_destroy
  labels                      = var.gcs_bucket.labels
  versioning                  = var.gcs_bucket.versioning
}

module "compute_instances" {
  source           = "./Modules/compute_instance"
  count            = length(var.compute_instances)
  project_id       = module.project.project_id
  name             = var.compute_instances[count.index].name
  machine_type     = var.compute_instances[count.index].machine_type
  zone             = var.compute_instances[count.index].zone
  image            = var.compute_instances[count.index].image
  disk_size_gb     = var.compute_instances[count.index].disk_size_gb
  disk_type        = var.compute_instances[count.index].disk_type
  network          = var.compute_instances[count.index].network
  subnetwork       = var.compute_instances[count.index].subnetwork
  assign_public_ip = var.compute_instances[count.index].assign_public_ip
  tags             = var.compute_instances[count.index].tags
  metadata         = var.compute_instances[count.index].metadata
  labels           = var.compute_instances[count.index].labels
}
