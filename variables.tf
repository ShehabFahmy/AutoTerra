variable "project" {
  type = object({
    project_name     = string
    project_id       = string
    organization_id  = string
    billing_account  = string
    deletion_policy  = string
    labels           = map(string)
    apis             = list(string)
  })
}

variable "vpc_name" {
  type = string
}

variable "subnets" {
  type = list(object({
    name   = string
    cidr   = string
    region = string
  }))
}

variable "firewall_rules" {
  type = list(object({
    name          = string
    protocol      = string
    ports         = list(string)
    source_ranges = list(string)
  }))
}
