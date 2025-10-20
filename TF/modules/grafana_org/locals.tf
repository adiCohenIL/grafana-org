#data "http" "okta_openid" {
#  url = "https://${var.okta_domain}/oauth2/default/.well-known/openid-configuration"
#}

locals {
  # Keycloak
  oauth_name          = "Keycloak"
  oauth_client_id     = "grafana"
  oauth_client_secret = "m92fecXo3OjKNAvdixUHTrVlG04hwiaL"
  auth_url            = "http://localhost:8080/realms/grafana/protocol/openid-connect/auth"
  token_url           = "http://localhost:8080/realms/grafana/protocol/openid-connect/token"
  api_url             = "http://localhost:8080/realms/grafana/protocol/openid-connect/userinfo"

  # OKTA
  #oauth_name          = "Okta""
  #oauth_client_id     = "grafana-client"
  #oauth_client_secret = "grafana-secret"
  #okta_openid = jsondecode(data.http.okta_openid.response_body)
  #auth_url            = local.okta_openid["authorization_endpoint"]
  #token_url           = local.okta_openid["token_endpoint"]
  #api_url             = local.okta_openid["userinfo_endpoint"]
}

