locals {
  grafana_basic_auth = "${var.grafana_auth.username}:${var.grafana_auth.password}"
}