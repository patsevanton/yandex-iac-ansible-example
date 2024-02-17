all:
  children:
    ipaserver:
      hosts:
        "openxpki":
          ansible_host: "${openxpki_public_ip}"
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    ssh_user: "${ssh_user}"
