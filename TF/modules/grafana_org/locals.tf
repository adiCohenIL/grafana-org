#data "http" "okta_openid" {
#  url = "https://${var.okta_domain}/oauth2/default/.well-known/openid-configuration"
#}

locals {
  # Keycloak
  oauth_name          = "Keycloak"
  oauth_client_id     = "grafana"
  oauth_client_secret = "m92fecXo3OjKNAvdixUHTrVlG04hwiaL"
  auth_url            = "http://keycloak:8080/realms/grafana/protocol/openid-connect/auth"
  token_url           = "http://keycloak:8080/realms/grafana/protocol/openid-connect/token"
  api_url             = "http://keycloak:8080/realms/grafana/protocol/openid-connect/userinfo"

  # OKTA
  #oauth_name          = "Okta""
  #oauth_client_id     = "grafana-client"
  #oauth_client_secret = "grafana-secret"
  #okta_openid = jsondecode(data.http.okta_openid.response_body)
  #auth_url            = local.okta_openid["authorization_endpoint"]
  #token_url           = local.okta_openid["token_endpoint"]
  #api_url             = local.okta_openid["userinfo_endpoint"]

  data_sources ={
    loki = {
      type = "loki"
      base_url = "http://loki"
      port     = 3100
    }
    mimir = {
      type = "prometheus"
      base_url = "http://mimir"
      port     = 9009
    }
    tempo = {
      type = "tempo"
      base_url = "http://mimir"
      port     = 3200
    }
  }

  # Compute DS display names
  data_source_names = {
    for datasource, values in local.data_sources :
    datasource => datasource == "mimir" ? "Mimir" : title(values.type)
  }

  environments = ["dev", "stage", "prod"]

  # Build env-specific data sources by adding env attribute to each DS
  data_source_env_map = {
    for env in local.environments :
    env => {
      for ds_key, ds_val in local.data_sources :
      "${ds_key}-${env}" => merge(ds_val, {
        env = env
        display_name = "${local.data_source_names[ds_key]}-${env}"
      })
    }
  }

  # Flatten nested maps into one
  data_source_env_flat = merge(values(local.data_source_env_map)...)
}