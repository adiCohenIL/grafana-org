
module "grafana_org_alpha" {
  source                   = "./modules/grafana_org"
  org_name                 = "Alpha"
  admin_users              = ["admin@example.com"]
  sailpoint_entitlement_id = "SP-GRAFANA-TEAM-Alpha"
  grafana_auth             = local.grafana_basic_auth
  grafana_url              = var.grafana_auth.url
#  okta_domain   = "TBD"
  providers = {
    grafana = grafana
  }
}


#module "grafana_org_beta" {
#  source                   = "./modules/grafana_org"
#  org_name                 = "Beta"
#  admin_users              = ["admin@beta.com"]
#  sailpoint_entitlement_id = "SP-GRAFANA-TEAM-Beta"
#  grafana_auth             = local.grafana_basic_auth
#  grafana_url              = var.grafana_auth.url
#  okta_domain   = "TBD"
#
#  providers = {
#    grafana = grafana
#  }
#}
