output "org_id" {
  value       = grafana_organization.org_name.org_id
  description = "Grafana organization ID"
}

output "organization_name" {
  value       = grafana_organization.org_name.name
  description = "Grafana organization name"
}

output "folder_id" {
  value       = grafana_folder.org_folder.id
  description = "Grafana folder ID"
}

output "dashboard_uid" {
  value       = grafana_dashboard.base.uid
  description = "Grafana dashbord uid"
}



output "org_mapping_applied" {
  description = "Grafana org_mapping setting"
  value = [for s in grafana_sso_settings.keycloack_sso.oauth2_settings : s.org_mapping][0]
}


