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
  source            = "./Modules/route"
  for_each          = var.routes
  project_id        = module.project.project_id
  vpc_self_link     = module.vpc.vpc_self_link
  name              = each.key
  dest_range        = each.value.dest_range
  next_hop_gateway  = each.value.next_hop_gateway
  next_hop_ip       = each.value.next_hop_ip
  next_hop_instance = each.value.next_hop_instance
  next_hop_ilb      = each.value.next_hop_ilb
  priority          = each.value.priority
  tags              = each.value.tags
}

module "subnets" {
  source        = "./Modules/subnet"
  for_each      = var.subnets
  project_id    = module.project.project_id
  vpc_self_link = module.vpc.vpc_self_link
  name          = each.key
  cidr          = each.value.cidr
  region        = each.value.region
}

module "firewall_rules" {
  source        = "./Modules/firewall_rule"
  for_each      = var.firewall_rules
  project_id    = module.project.project_id
  vpc_self_link = module.vpc.vpc_self_link
  name          = each.key
  protocol      = each.value.protocol
  ports         = each.value.ports
  source_ranges = each.value.source_ranges
}

module "compute_instances" {
  source           = "./Modules/compute_instance"
  for_each         = var.compute_instances
  project_id       = module.project.project_id
  name             = each.key
  machine_type     = each.value.machine_type
  zone             = each.value.zone
  image            = each.value.image
  disk_size_gb     = each.value.disk_size_gb
  disk_type        = each.value.disk_type
  network          = each.value.network
  subnetwork       = each.value.subnetwork
  assign_public_ip = each.value.assign_public_ip
  tags             = each.value.tags
  metadata         = each.value.metadata
  labels           = each.value.labels
}

module "load_balancers" {
  source              = "./Modules/load_balancer"
  for_each            = var.load_balancers
  project_id          = module.project.project_id
  lb_name             = each.key
  protocol            = each.value.protocol
  internal            = each.value.internal
  frontend_port       = each.value.frontend_port
  backend_port        = each.value.backend_port
  health_check_port   = each.value.health_check_port
  instance_group_name = each.value.instance_group_name
  instance_group_zone = each.value.instance_group_zone
  instances           = [for inst in each.value.instances : module.compute_instances[inst].self_link]
}
