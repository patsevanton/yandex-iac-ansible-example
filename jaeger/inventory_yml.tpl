all:
  children:
    jaeger:
      hosts:
        "${hostname}":
          ansible_host: "${public_ip}"
  vars:
    jaeger_external_url: "https://${hostname}.${public_ip}.${domain}"
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
