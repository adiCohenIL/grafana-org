#data "http" "okta_openid" {
#  url = "https://${var.okta_domain}/oauth2/default/.well-known/openid-configuration"
#}

locals {
  # Dex
  oauth_name          = "Dex"
  oauth_client_id     = "grafana-client"
  oauth_client_secret = "grafana-secret"
  auth_url            = "http://localhost:5556/dex/auth"
  token_url           = "http://dex:5556/dex/token"
  api_url             = "http://dex:5556/dex/userinfo"

  # OKTA
  #oauth_name          = "Okta""
  #oauth_client_id     = "grafana-client"
  #oauth_client_secret = "grafana-secret"
  #okta_openid = jsondecode(data.http.okta_openid.response_body)
  #auth_url            = local.okta_openid["authorization_endpoint"]
  #token_url           = local.okta_openid["token_endpoint"]
  #api_url             = local.okta_openid["userinfo_endpoint"]
}

