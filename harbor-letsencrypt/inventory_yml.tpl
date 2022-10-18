all:
  children:
    harbor:
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
    harbor_ui_url_protocol: https
    harbor_admin_password: superpassword
    harbor_hostname: ${hostname}.${public_ip}.${domain}
    harbor_ssl_cert: /etc/letsencrypt/live/${hostname}.${public_ip}.${domain}/cert.pem
    harbor_ssl_cert_key: /etc/letsencrypt/live/${hostname}.${public_ip}.${domain}/privkey.pem
    harbor_installer_with:
      - --with-trivy
