logging {
  level  = "info"
  format = "logfmt"
}

local.file_match "Mirai" {
  path_targets = [ { "__path__" = "/logs/system.log", "service_name" = "Mirai"    } ]
  sync_period  = "1s"
}
local.file_match "MyChange" {
  path_targets = [ { "__path__" = "/logs/wifi.log",   "service_name" = "MyChange" } ]
  sync_period  = "1s"
}

loki.source.file "Mirai" {
  targets       = local.file_match.Mirai.targets
  forward_to    = [loki.write.Mirai.receiver]
  tail_from_end = true
}
loki.source.file "MyChange" {
  targets       = local.file_match.MyChange.targets
  forward_to    = [loki.write.MyChange.receiver]
  tail_from_end = true
}

loki.write "Mirai" {
  endpoint {
    url     = "http://loki:3100/loki/api/v1/push"
    headers = { "X-Scope-OrgID" = "Mirai" }
  }
}
loki.write "MyChange" {
  endpoint {
    url     = "http://loki:3100/loki/api/v1/push"
    headers = { "X-Scope-OrgID" = "MyChange" }
  }
}
