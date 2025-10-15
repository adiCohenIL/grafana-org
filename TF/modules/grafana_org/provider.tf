provider "grafana" {
  alias  = "new_org"
  auth   = var.grafana_auth
  url    = var.grafana_url
  org_id = grafana_organization.org_name.org_id
}

terraform {
  required_providers {
    grafana = {
      source                = "grafana/grafana"
      version               = ">= 4.10.0"
      configuration_aliases = [grafana.new_org]
    }
  }
}