variable "name" {
  type        = string
}

variable "vpc_self_link" {
  type        = string
}

variable "project_id" {
  type        = string
}

variable "protocol" {
  type        = string
}

variable "ports" {
  type        = list(string)
}

variable "source_ranges" {
  type        = list(string)
}
