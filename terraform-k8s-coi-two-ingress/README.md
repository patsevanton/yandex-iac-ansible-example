test
```hcl
  scale_policy {
    auto_scale {
      initial_size = 5
      max_size = 15
      measurement_duration = 30
      min_zone_size = 3
      stabilization_duration = 120
      warmup_duration = 60
      custom_rule = [
        {
          labels = {
            network_load_balancer = "id"
          }
          metric_name = "network_load_balancer.processed_packets"
          metric_type = "GAUGE"
          rule_type = "WORKLOAD"
          target = 5
        },
        {
          labels = {
            network_load_balancer = "id"
          }
          metric_name = "network_load_balancer.processed_bytes"
          metric_type = "GAUGE"
          rule_type = "WORKLOAD"
          target = 5
        }
      ]
    }
  }
```
