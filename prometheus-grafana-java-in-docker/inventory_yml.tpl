all:
  children:
    ${hostname_prometheus}:
      hosts:
        "${hostname_prometheus}":
          ansible_host: "${public_ip_prometheus}"
    ${hostname_javaindocker}:
      hosts:
        "${hostname_javaindocker}":
          ansible_host: "${public_ip_javaindocker}"
  vars:
    #grafana_url: "http://${hostname_prometheus}.${public_ip_prometheus}.${domain}"
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    prometheus_scrape_configs:
      - job_name: "node"
        static_configs:
          - targets:
              - ${public_ip_javaindocker}:9100
      - job_name: cadvisor
        metrics_path: "/metrics"
        scrape_interval: 10s
        honor_labels: true
        scheme: http
        static_configs:
          - targets:
              - ${public_ip_javaindocker}:9280
      - job_name: jmx
        static_configs:
          - targets:
              - ${public_ip_javaindocker}:5556
    prometheus_components: [ "prometheus", "node_exporter" ]
    grafana_use_provisioning: true
    grafana_security:
      admin_user: admin
      admin_password: enter_your_secure_password
    grafana_datasources:
      - name: prometheus
        type: prometheus
        access: proxy
        url: 'http://localhost:9090'
        basicAuth: false
    grafana_dashboards:
      # Node Exporter Full:
      - dashboard_id: 1860
        revision_id: 26
        datasource: prometheus
      # Cadvisor exporter:
      - dashboard_id: 14282
        revision_id: 1
        datasource: prometheus
      # JMX Dashboard(Basic):
      #- dashboard_id: 14845
      #  revision_id: 1
      #  datasource: prometheus
      # Fork JMX Dashboard(Basic):
      - dashboard_id: 16179
        revision_id: 1
        datasource: prometheus
      # Process exporter dashboard with treemap:
      - dashboard_id: 13882
        revision_id: 9
        datasource: prometheus

#### grafana-cli plugins install marcusolsson-treemap-panel
