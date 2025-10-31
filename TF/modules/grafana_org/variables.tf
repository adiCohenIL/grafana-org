variable "org_name" {
  description = "Grafana organization name"
  type        = string
  #Validation can be added if there is a convention
}

variable "admin_users" {
  description = "List of emails of organization admin"
  type        = list(string)
  validation {
    condition = alltrue([
      for email in var.admin_users : can(regex("^\\S+@\\S+\\.\\S+$", email))
    ])
    error_message = "Each item in admin_users must be a valid email address."
  }
}

variable "sailpoint_entitlement_id" {
  description = "SailPoint entitlement id"
  type        = string
  #Validation can be added if there is a convention
}

variable "grafana_auth" {
  description = "grafana auth"
  type        = string
}

variable "grafana_url" {
  description = "grafana url"
  type        = string
}

#variable okta_domain {
#  description = "Okta domain for discovery"
#  type        = string
#}
