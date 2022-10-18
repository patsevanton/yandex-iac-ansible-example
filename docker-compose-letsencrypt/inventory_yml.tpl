all:
  children:
    docker:
      hosts:
        "${hostname}":
          ansible_host: "${public_ip}"
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    docker_external_url: "${hostname}.${public_ip}.${letsencrypt_domain}"
