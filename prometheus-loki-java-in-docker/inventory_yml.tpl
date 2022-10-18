all:
  children:
    ${hostname_prometheus}:
      hosts:
        "${hostname_prometheus}":
          ansible_host: "${public_ip_prometheus}"
          has_loki: true
    ${hostname_javaindocker}:
      hosts:
        "${hostname_javaindocker}":
          ansible_host: "${public_ip_javaindocker}"
          promtail_loki_server_url: http://${public_ip_prometheus}:3100
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    letsencrypt_opts_extra: "--register-unsafely-without-email"
    letsencrypt_cert:
      name: ${hostname_prometheus}.${public_ip_prometheus}.${domain}
      domains:
        - ${hostname_prometheus}.${public_ip_prometheus}.${domain}
      challenge: http
      http_auth: standalone
      reuse_key: True
    nginx_vhosts:
      - listen: "443 ssl"
        server_name: ${hostname_prometheus}.${public_ip_prometheus}.${domain}
        index: "index.php index.html index.htm"
        state: "present"
        extra_parameters: |
          location / {
            proxy_pass http://localhost:3000/;
            proxy_set_header Host $host;
          }
          ssl_certificate     /etc/letsencrypt/live/${hostname_prometheus}.${public_ip_prometheus}.${domain}/cert.pem;
          ssl_certificate_key /etc/letsencrypt/live/${hostname_prometheus}.${public_ip_prometheus}.${domain}/privkey.pem;
    docker_daemon_options:
      "log-driver": "json-file"
      "log-opts":
          "max-size": "100m"
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
      - name: loki
        type: loki
        access: proxy
        url: 'http://localhost:3100'
        basicAuth: false
      - name: prometheus
        type: prometheus
        access: proxy
        url: 'http://localhost:9090'
        basicAuth: false
    promtail_config_scrape_configs:
      - job_name: flog_scrape
        docker_sd_configs:
          - host: unix:///var/run/docker.sock
            refresh_interval: 5s
        relabel_configs:
          - source_labels: ['__meta_docker_container_name']
            regex: '/(.*)'
            target_label: 'container'
    grafana_dashboards:
      # Node Exporter Full:
      - dashboard_id: 1860
        revision_id: 26
        datasource: prometheus
      # Cadvisor exporter:
      - dashboard_id: 14282
        revision_id: 1
        datasource: prometheus
      - dashboard_id: 16179
        revision_id: 1
        datasource: prometheus

#### grafana-cli plugins install marcusolsson-treemap-panel
