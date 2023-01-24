test
```hcl
  scale_policy {
    auto_scale {
      initial_size           = 3
      measurement_duration   = 60
      cpu_utilization_target = 75
      custom_rule {
          labels = {
              network_load_balancer = yandex_lb_network_load_balancer.sni_balancer.id
          }
          metric_name = "network_load_balancer.processed_packets"
          metric_type = "GAUGE"
          rule_type = "WORKLOAD"
          target = 5
      }
      custom_rule {
          labels = {
              network_load_balancer = yandex_lb_network_load_balancer.sni_balancer.id
          }
          metric_name = "network_load_balancer.processed_bytes"
          metric_type = "GAUGE"
          rule_type = "WORKLOAD"
          target = 5
      }
      min_zone_size          = 1
      max_size               = 15
      warmup_duration        = 60
      stabilization_duration = 120
    }
}
```
