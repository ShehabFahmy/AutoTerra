variable "project" {
  type = object({
    project_name    = string
    project_id      = string
    organization_id = string
    billing_account = string
    deletion_policy = string
    labels          = map(string)
    apis            = list(string)
  })
}

variable "vpc_name" {
  type = string
}

variable "routes" {
  type = map(object({
    name              = string
    dest_range        = string
    next_hop_gateway  = optional(string)
    next_hop_ip       = optional(string)
    next_hop_instance = optional(string)
    next_hop_ilb      = optional(string)
    priority          = optional(number)
    tags              = optional(list(string))
  }))
  default = {}
}

variable "subnets" {
  type = map(object({
    name   = string
    cidr   = string
    region = string
  }))
}

variable "firewall_rules" {
  type = map(object({
    name          = string
    protocol      = string
    ports         = list(string)
    source_ranges = list(string)
  }))
}

variable "compute_instances" {
  type = map(object({
    machine_type     = string
    zone             = string
    image            = string
    network          = string
    subnetwork       = string
    assign_public_ip = optional(bool)
    disk_size_gb     = optional(number)
    disk_type        = optional(string)
    tags             = optional(list(string))
    metadata         = optional(map(string))
    labels           = optional(map(string))
  }))
}

variable "load_balancers" {
  type = map(object({
    protocol            = string # "HTTP or HTTPS"
    internal            = bool   # true => internal LB, false => external LB
    frontend_port       = string
    backend_port        = string
    health_check_port   = string
    instance_group_name = string
    instance_group_zone = string
    instances           = list(string)
  }))
}
