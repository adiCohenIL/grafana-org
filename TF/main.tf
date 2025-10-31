module "grafana_org_beta" {
  source                   = "./modules/grafana_org"
  org_name                 = "Beta"
  sailpoint_entitlement_id = "SP-GRAFANA-TEAM-Beta"
  admin_users              = ["admin@example.com"]
  grafana_auth             = local.grafana_basic_auth
  grafana_url              = var.grafana_auth.url
  #  okta_domain   = "TBD"
  providers = {
    grafana = grafana
  }
}

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


#Set globaly, set once and overwriting pervious settings
resource "grafana_sso_settings" "keycloack_sso" {
  provider_name = "generic_oauth"

  oauth2_settings {
    name          = local.oauth_name
    client_id     = local.oauth_client_id
    client_secret = local.oauth_client_secret
    auth_url      = local.auth_url
    token_url     = local.token_url
    api_url       = local.api_url
    allow_sign_up = true

    scopes               = "openid profile email"
    name_attribute_path  = "name"
    login_attribute_path = "preferred_username"
    email_attribute_name = "email"

    #TODO - fix for grafana current settings
    role_attribute_path = "contains(groups[*], 'Team-Admins') && 'Admin' || 'None'"

    # Dynamic org mapping
    org_attribute_path         = "groups"
    org_mapping                = local.org_mapping_string
    allow_assign_grafana_admin = true
  }
}