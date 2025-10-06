variable "config" {
  description = "Cloud Run configuration object"
  type = object({
    project_id             = string
    name                   = string
    location               = optional(string, "us-central1")
    image                  = optional(string, "gcr.io/cloudrun/hello")
    allow_unauthenticated  = optional(bool, false)
    vpc_connector          = optional(string)
    egress                 = optional(string)
    env                    = optional(map(string), {})
    annotations            = optional(map(string), {})
    container_port         = optional(number, 8080)
    command                = optional(list(string), [])
    args                   = optional(list(string), [])
    service_account_email  = optional(string)
    min_scale              = optional(number)
    max_scale              = optional(number)
    container_concurrency  = optional(number)
    timeout_seconds        = optional(number)
    ingress                = optional(string)
  })
}
