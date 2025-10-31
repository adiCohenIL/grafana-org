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

