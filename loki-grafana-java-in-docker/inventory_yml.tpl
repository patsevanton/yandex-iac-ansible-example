all:
  children:
    ${hostname_loki}:
      hosts:
        "${hostname_loki}":
          ansible_host: "${public_ip_loki}"
          has_loki: true
    ${hostname_javaindocker}:
      hosts:
        "${hostname_javaindocker}":
          ansible_host: "${public_ip_javaindocker}"
          promtail_loki_server_url: http://${public_ip_loki}:3100 
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    letsencrypt_opts_extra: "--register-unsafely-without-email"
    letsencrypt_cert:
      name: ${hostname_loki}.${public_ip_loki}.${domain}
      domains:
        - ${hostname_loki}.${public_ip_loki}.${domain}
      challenge: http
      http_auth: standalone
      reuse_key: True
    nginx_vhosts:
      - listen: "443 ssl"
        server_name: ${hostname_loki}.${public_ip_loki}.${domain}
        index: "index.php index.html index.htm"
        state: "present"
        extra_parameters: |
          location / {
            proxy_pass http://localhost:3000/;
            proxy_set_header Host $host;
          }
          ssl_certificate     /etc/letsencrypt/live/${hostname_loki}.${public_ip_loki}.${domain}/cert.pem;
          ssl_certificate_key /etc/letsencrypt/live/${hostname_loki}.${public_ip_loki}.${domain}/privkey.pem;
    docker_daemon_options:
      "log-driver": "json-file"
      "log-opts":
          "max-size": "100m"
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
    promtail_config_scrape_configs:
      - job_name: flog_scrape 
        docker_sd_configs:
          - host: unix:///var/run/docker.sock
            refresh_interval: 5s
        relabel_configs:
          - source_labels: ['__meta_docker_container_name']
            regex: '/(.*)'
            target_label: 'container'
