all:
  children:
    jenkins:
      hosts:
        "${hostname}":
          ansible_host: "${public_ip}"
  vars:
    jenkins_prefer_lts: true
    jenkins_external_url: "https://${hostname}.${public_ip}.${domain}"
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa

    jenkins_casc_admin_password: ${jenkins_admin_password}
    jenkins_admin_password: ${jenkins_admin_password}
    jenkins_hostname: "${hostname}.${public_ip}.${domain}"
    jenkins_plugins:
        - name: cloudbees-folder
        - name: antisamy-markup-formatter
        - name: build-timeout
        - name: credentials-binding
        - name: timestamper
        - name: ws-cleanup
        - name: ant
        - name: gradle
        - name: workflow-aggregator
        - name: github-branch-source
        - name: pipeline-github-lib
        - name: pipeline-stage-view
        - name: git
        - name: ssh-slaves
        - name: matrix-auth
        - name: pam-auth
        - name: ldap
        - name: email-ext
        - name: mailer
        - name: oic-auth
        - name: configuration-as-code

    letsencrypt_opts_extra: "--register-unsafely-without-email"
    letsencrypt_cert:
      name: ${hostname}.${public_ip}.${domain}
      domains:
        - ${hostname}.${public_ip}.${domain}
      challenge: http
      http_auth: standalone
      reuse_key: True
    
    nginx_remove_default_vhost: true
    nginx_vhosts:
      - listen: "80"
        server_name: "${hostname}.${public_ip}.${domain}"
        return: "301 https://${hostname}.${public_ip}.${domain}$request_uri"
        filename: "${hostname}.${public_ip}.${domain}.80.conf"
      - listen: "443 ssl"
        server_name: ${hostname}.${public_ip}.${domain}
        state: "present"
        extra_parameters: |
          location / {
            proxy_set_header        Host $host:$server_port;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;

            # Fix the "It appears that your reverse proxy set up is broken" error.
            proxy_pass          http://127.0.0.1:8080;
            proxy_read_timeout  90;

          }
          ssl_certificate     /etc/letsencrypt/live/${hostname}.${public_ip}.${domain}/cert.pem;
          ssl_certificate_key /etc/letsencrypt/live/${hostname}.${public_ip}.${domain}/privkey.pem;
