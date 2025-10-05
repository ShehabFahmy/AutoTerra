module "google_project" {
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
  project_id = module.google_project.project_id
}

module "subnets" {
  source        = "./Modules/subnet"
  count         = length(var.subnets)
  name          = var.subnets[count.index].name
  cidr          = var.subnets[count.index].cidr
  region        = var.subnets[count.index].region
  vpc_self_link = module.vpc.vpc_self_link
  project_id = module.google_project.project_id
}

module "firewall_rules" {
  source        = "./Modules/firewall_rule"
  count         = length(var.firewall_rules)
  name          = var.firewall_rules[count.index].name
  vpc_self_link = module.vpc.vpc_self_link
  project_id = module.google_project.project_id
  protocol      = var.firewall_rules[count.index].protocol
  ports         = var.firewall_rules[count.index].ports
  source_ranges = var.firewall_rules[count.index].source_ranges
}