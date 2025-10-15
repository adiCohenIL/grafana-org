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

resource "grafana_dashboard" "base" {
  folder      = grafana_folder.org_folder.id
  org_id      = grafana_organization.org_name.org_id
  config_json = file("${path.module}/dashboard.json")
}

resource "grafana_organization_preferences" "base" {
  theme              = "dark"
  timezone           = "utc"
  week_start         = "monday"
  org_id             = grafana_organization.org_name.org_id
  home_dashboard_uid = grafana_dashboard.base.uid
}

resource "grafana_sso_settings" "dex_sso" {
  provider_name = "generic_oauth"

  oauth2_settings {
    name          = local.oauth_name
    client_id     = local.oauth_client_id
    client_secret = local.oauth_client_secret
    auth_url      = local.auth_url
    token_url     = local.token_url
    api_url       = local.api_url
    allow_sign_up = true
    scopes        = "openid profile email groups"

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