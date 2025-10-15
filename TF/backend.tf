
terraform {
  required_version = ">= 1.10.5"

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 4.10.0"
    }
  }

  # TBD with ASML
  #  backend "s3" {
  #    bucket       = "some-tfstate-bucket"
  #    key          = "<path>/terraform.tfstate"
  #    region       = "eu-west-1"
  #    encrypt      = true
  #    use_lockfile = true
  #  }
}

provider "grafana" {
  url = var.grafana_auth.url
  #auth  = var.grafana_auth.token
  auth = local.grafana_basic_auth
}
