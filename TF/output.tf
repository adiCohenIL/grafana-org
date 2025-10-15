output "org_id" {
  value       = module.grafana_org_alpha.org_id
  description = "Grafana new organization ID"
}

output "org_name" {
  value = module.grafana_org_alpha.organization_name
  description = "Grafana new organization name"
}

output "folder_id" {
  value = module.grafana_org_alpha.folder_id
  description = "Grafana folder ID created for new organizartion"
}

output "dashboard_uid" {
  value = module.grafana_org_alpha.dashboard_uid
  description = "Grafana new organization default dashbord uid"
}