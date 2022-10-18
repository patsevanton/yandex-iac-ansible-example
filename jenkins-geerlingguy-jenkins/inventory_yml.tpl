all:
  children:
    jenkins:
      hosts:
        "${hostname}":
          ansible_host: "${public_ip}"
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa

    jenkins_prefer_lts: true
    #jenkins_version: "2.346"
    jenkins_external_url: "https://${hostname}.${public_ip}.${domain}"
    jenkins_admin_password: ${jenkins_admin_password}
    jenkins_hostname: "${hostname}.${public_ip}.${domain}"
    googleoauth2_clientid: ${googleoauth2_clientid}
    googleoauth2_clientsecret: ${googleoauth2_clientsecret}
    googleoauth2_domain: ${googleoauth2_domain}
    jenkins_java_options: "-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"

    jenkins_init_changes:
      - option: "JAVA_OPTS"
        value: "{{ jenkins_java_options }}"
      - option: "CASC_JENKINS_CONFIG"
        value: "/var/lib/jenkins/jcasc/"

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
