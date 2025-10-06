variable "instances" {
  type = list(string)
  description = "List of instance self-links for the instance group"
}

variable "instance_group_name" {
  type        = string
  description = "Name of the backend instance group"
}

variable "instance_group_zone" {
  type        = string
  description = "Zone of the backend instance group"
}

variable "project_id" {
  type        = string
  description = "Project ID where the load balancer is created"
}

variable "lb_name" {
  type        = string
  description = "Name of the load balancer"
}

variable "protocol" {
  type        = string
  description = "Protocol used by the load balancer (HTTP or HTTPS)"
  default     = "HTTP"
}

variable "internal" {
  type        = bool
  description = "Whether the load balancer is internal or external"
  default     = false
}

variable "frontend_port" {
  type        = string
  description = "Frontend port exposed by the load balancer"
}

variable "backend_port" {
  type        = string
  description = "Backend port where instances listen"
}

variable "health_check_port" {
  type        = string
  description = "Backend port checked by the load balancer for health"
}