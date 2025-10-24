resource "grafana_organization" "org_name" {
  name         = var.org_name
  admin_user   = "admin"
  create_users = true
  admins       = var.admin_users
}

resource "grafana_folder" "org_folder" {
  provider = grafana.new_org
  title    = "${var.org_name} Dashboards [SP: ${var.sailpoint_entitlement_id}]"
  org_id   = grafana_organization.org_name.org_id
}

#DO NOT have header  X-Grafana-Org-Id set 
resource "grafana_dashboard" "base" {
  provider = grafana.new_org
  folder      = grafana_folder.org_folder.id
  org_id      = grafana_organization.org_name.org_id
  config_json = file("${path.module}/dashboard.json")
}

resource "grafana_organization_preferences" "base" {
  provider = grafana.new_org
  theme              = "dark"
  timezone           = "utc"
  week_start         = "monday"
  org_id             = grafana_organization.org_name.org_id
  home_dashboard_uid = grafana_dashboard.base.uid
}

resource "grafana_data_source" "ds" {
  provider = grafana.new_org

#  for_each = local.data_sources
  for_each = local.data_source_env_flat
  name        = "${each.value.display_name}-${var.org_name}"
  type        = each.value.type
  url         = "${each.value.base_url}:${each.value.port}"
  access_mode    = "proxy"
  is_default = false

  http_headers = {
    "X-Scope-OrgID" = var.org_name
  }
  org_id   = grafana_organization.org_name.org_id
}

#INITIAL DS NOT DRY#resource "grafana_data_source" "loki" {
#INITIAL DS NOT DRY#  provider = grafana.new_org
#INITIAL DS NOT DRY#  name      = "Loki-${grafana_organization.org_name.org_id}"
#INITIAL DS NOT DRY#  type      = "loki"
#INITIAL DS NOT DRY#  url       = "http://loki:3100"
#INITIAL DS NOT DRY#  access_mode    = "proxy"
#INITIAL DS NOT DRY#  is_default = false
#INITIAL DS NOT DRY#
#INITIAL DS NOT DRY#  http_headers = {
#INITIAL DS NOT DRY#    "X-Scope-OrgID" = var.org_name
#INITIAL DS NOT DRY#  }
#INITIAL DS NOT DRY#  org_id   = grafana_organization.org_name.org_id
#INITIAL DS NOT DRY#}
#INITIAL DS NOT DRY#
#INITIAL DS NOT DRY#resource "grafana_data_source" "tempo" {
#INITIAL DS NOT DRY#  provider = grafana.new_org
#INITIAL DS NOT DRY#  name        = "Tempo"
#INITIAL DS NOT DRY#  type        = "tempo"
#INITIAL DS NOT DRY#  url         = "http://tempo:3200"
#INITIAL DS NOT DRY#  access_mode = "proxy"
#INITIAL DS NOT DRY#  is_default  = false
#INITIAL DS NOT DRY#
#INITIAL DS NOT DRY#  http_headers = {
#INITIAL DS NOT DRY#    "X-Scope-OrgID" = var.org_name
#INITIAL DS NOT DRY#  }
#INITIAL DS NOT DRY#  org_id   = grafana_organization.org_name.org_id
#INITIAL DS NOT DRY#}
#INITIAL DS NOT DRY#
#INITIAL DS NOT DRY#resource "grafana_data_source" "mimir" {
#INITIAL DS NOT DRY#  provider = grafana.new_org
#INITIAL DS NOT DRY#  name        = "Mimir"
#INITIAL DS NOT DRY#  type        = "prometheus"
#INITIAL DS NOT DRY#  url         = "https://mimir.example.com"
#INITIAL DS NOT DRY#  access_mode = "proxy"
#INITIAL DS NOT DRY#  is_default  = false
#INITIAL DS NOT DRY#
#INITIAL DS NOT DRY#  http_headers = {
#INITIAL DS NOT DRY#    "X-Scope-OrgID" = var.org_name
#INITIAL DS NOT DRY#  }
#INITIAL DS NOT DRY#  org_id   = grafana_organization.org_name.org_id
#INITIAL DS NOT DRY#}

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
    #scopes        = "openid profile email groups"

    scopes        = "openid profile email"
    name_attribute_path  = "name"
    login_attribute_path = "preferred_username"
    email_attribute_name = "email"

    # Dynamic role mapping per org
    role_attribute_path = <<EOF
      contains(groups[*], 'Team${var.org_name}-Admins') && 'Admin' || 
      contains(groups[*], 'Team${var.org_name}-Editors') && 'Editor' || 
      contains(groups[*], 'Team${var.org_name}-Viewers') && 'Viewer' || ''
    EOF

    # Dynamic org mapping
    org_attribute_path = "groups"
    org_mapping = replace(<<EOF
      Team${var.org_name}-Admins:${var.org_name}:Admin,
      Team${var.org_name}-Editors:${var.org_name}:Editor,
      Team${var.org_name}-Viewers:${var.org_name}:Viewer
    EOF
    , "/\\s+/", "")

    allow_assign_grafana_admin = true
  }
}