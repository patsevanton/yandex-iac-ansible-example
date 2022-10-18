all:
  children:
    vm-single:
      hosts:
        "${hostname}":
          ansible_host: "${victoriametrics_public_ip}"
  vars:
    #victoriametrics_external_url: "https://${hostname}.${victoriametrics_public_ip}.${domain}"
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    vmagent_scrape_config:
      scrape_configs:
        - job_name: node
          static_configs:
            - targets:
              - localhost:9100
    prometheus_components: [ "prometheus", "node_exporter" ]
    grafana_use_provisioning: true
    grafana_security:
      admin_user: admin
      admin_password: enter_your_secure_password
    grafana_datasources:
      - name: prometheus
        type: prometheus
        access: proxy
        url: 'http://localhost:8428'
        basicAuth: false
    grafana_dashboards:
      - dashboard_id: 10229
        revision_id: 22
        datasource: prometheus
      - dashboard_id: 12683
        revision_id: 7
        datasource: prometheus
      - dashboard_id: 1860
        revision_id: 26
        datasource: prometheus
