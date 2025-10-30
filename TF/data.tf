##resource "null_resource" "fetch_grafana_settings" {
##  provisioner "local-exec" {
##    command = "curl -u ${local.grafana_basic_auth} http://localhost:3000/api/admin/settings -o ${path.module}/grafana_settings.json"
##  }
##}
##
##data "external" "grafana_settings_before" {
##  program    = ["python3", "${path.module}/read_oauth_settings.py", "${path.module}/grafana_settings.json"]
##  depends_on = [null_resource.fetch_grafana_settings]
##}
##
##output "sso_settings_before" {
##  value = data.external.grafana_settings_before.result
##}
##
##resource "null_resource" "fetch_after" {
##  provisioner "local-exec" {
##    command = "curl -u ${local.grafana_basic_auth} http://localhost:3000/api/admin/settings > ${path.module}/after.json"
##  }
##}
##
##
##data "external" "grafana_settings_after" {
##  program    = ["python3", "${path.module}/read_oauth_settings.py", "${path.module}/after.json"]
##  depends_on = [module.grafana_org_beta]
##}
##
##
##output "sso_settings_after" {
##  value = data.external.grafana_settings_after.result
##}
##
##
##### dummy resource just to enforce run before 
##resource "null_resource" "gate_module_start" {
##  depends_on = [null_resource.fetch_grafana_settings]
##
##  provisioner "local-exec" {
##    command = "echo 'Starting grafana_org_beta module'"
##  }
##}