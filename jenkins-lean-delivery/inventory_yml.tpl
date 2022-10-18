all:
  children:
    jenkins:
      hosts:
        "${hostname}":
          ansible_host: "${public_ip}"
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa

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
