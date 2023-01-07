all:
  children:
    ipaserver:
      hosts:
        "${hostname}":
          ansible_host: "${freeipa_public_ip}"
  vars:
    #freeipa_external_url: "https://${hostname}.${freeipa_public_ip}.${letsencrypt_domain}"
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    ipaadmin_password: ADMPassword1
    ipadm_password: DMPassword1
    #ipaserver_domain: ${hostname}.ru-central1.internal
    #ipaserver_realm: ${hostname}.ru-central1.internal
    ipaserver_domain: ${hostname}.${freeipa_public_ip}.${letsencrypt_domain}
    ipaserver_realm: ${hostname}.${freeipa_public_ip}.${letsencrypt_domain}
    ipaserver_ip_addresses:
      - '{{ ansible_default_ipv4.address|default(ansible_all_ipv4_addresses[0]) }}'
