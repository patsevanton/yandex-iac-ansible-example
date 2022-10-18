all:
  children:
    sonarqube:
      hosts:
        "${hostname}":
          ansible_host: "${public_ip}"
  vars:
    sonarqube_external_url: "https://${hostname}.${public_ip}.${domain}"
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
