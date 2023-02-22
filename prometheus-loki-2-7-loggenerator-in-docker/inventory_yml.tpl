all:
  children:
    ${hostname_lokiindocker}:
      hosts:
        "${hostname_lokiindocker}":
          ansible_host: "${public_ip_lokiindocker}"
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
