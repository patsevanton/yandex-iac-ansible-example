all:
  children:
    jenkins:
      hosts:
        "${hostname}":
          ansible_host: "${public_ip}"
  vars:
    jenkins_external_url: "http://${hostname}.${public_ip}.${domain}"
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa

    nginx_vhosts:
      - listen: "80"
        server_name: ${hostname}.${public_ip}.${domain}
        state: "present"
        extra_parameters: |
          location / {
            proxy_pass http://localhost:8080/;
            proxy_read_timeout  90s;
            proxy_redirect http://localhost:8080 http://${hostname}.${public_ip}.${domain};
          }
