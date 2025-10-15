
variable "grafana_auth" {
  description = "grafana SA auth details"
  type = object({
    token    = string
    url      = string
    username = string
    password = string
  })
  default = {
    token    = "glsa_xIhPw9lwb8OgVsbf5LyWfvO0OoGxbCdV_8a0c6122"
    url      = "http://localhost:3000"
    username = "grafana"
    password = "superuser"
  }
}

