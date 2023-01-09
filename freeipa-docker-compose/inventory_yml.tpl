all:
  children:
    ipaserver:
      hosts:
        "freeipa":
          ansible_host: "${freeipa_public_ip}"
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    freeipa_password: "${freeipa_password}"
    freeipa_fqdn: "${freeipa_fqdn}"
