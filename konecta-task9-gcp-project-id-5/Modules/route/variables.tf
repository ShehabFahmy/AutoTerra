variable "project_id" {
  description = "The ID of the project where the route will be created."
  type        = string
}

variable "name" {
  description = "The name of the route."
  type        = string
}

variable "vpc_self_link" {
  description = "The self link or ID of the network to attach the route to."
  type        = string
}

variable "dest_range" {
  description = "The destination IP range of outgoing packets that this route applies to."
  type        = string
}

variable "priority" {
  description = "Priority of the route (lower number means higher priority). Default is 1000."
  type        = number
  default     = 1000
}

variable "next_hop_gateway" {
  description = "The URL or name of the next hop gateway (e.g. default-internet-gateway)."
  type        = string
  default     = null
}

variable "next_hop_ip" {
  description = "The IP address of the next hop. Mutually exclusive with other next hop fields."
  type        = string
  default     = null
}

variable "next_hop_instance" {
  description = "The instance name or self link of the next hop instance."
  type        = string
  default     = null
}

variable "next_hop_ilb" {
  description = "The URL of the next hop internal load balancer."
  type        = string
  default     = null
}

variable "tags" {
  description = "List of instance tags this route applies to. Leave empty for all instances."
  type        = list(string)
  default     = []
}
