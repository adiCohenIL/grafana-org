resource "grafana_organization" "org_name" {
  name = var.org_name
  #admin_user   = "admin"
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
  provider    = grafana.new_org
  folder      = grafana_folder.org_folder.id
  org_id      = grafana_organization.org_name.org_id
  config_json = file("${path.module}/dashboard.json")
}

resource "grafana_organization_preferences" "base" {
  provider           = grafana.new_org
  theme              = "dark"
  timezone           = "utc"
  week_start         = "monday"
  org_id             = grafana_organization.org_name.org_id
  home_dashboard_uid = grafana_dashboard.base.uid
}

###resource "grafana_data_source" "ds" {
###  provider = grafana.new_org
###
###  for_each    = local.data_source_env_flat
###  name        = "${each.value.display_name}-${var.org_name}"
###  type        = each.value.type
###  url         = each.value.url
###  access_mode = "proxy"
###  is_default  = false
###
###  http_headers = {
###    "X-Scope-OrgID" = var.org_name
###  }
###  org_id = grafana_organization.org_name.org_id
###}