all:
  children:
    ipaserver:
      hosts:
        "${freeipa_hostname}":
      vars:
        ansible_host: "${freeipa_public_ip}"
        ansible_user:  ${ssh_freeipa_user}
        ansible_ssh_private_key_file: ~/.ssh/id_rsa
        ipaadmin_password: ADMPassword1
        ipadm_password: DMPassword1
        ipaserver_domain: ${freeipa_public_ip}.${letsencrypt_domain}
        ipaserver_realm: ${freeipa_public_ip}.${letsencrypt_domain}
        ipaserver_ip_addresses:
          - '{{ ansible_default_ipv4.address|default(ansible_all_ipv4_addresses[0]) }}'
        pswd_test_user_in_freeipa: ${pswd_test_user_in_freeipa}
        pswd_gitlab_ldap_sync: ${pswd_gitlab_ldap_sync}
    gitlab:
      hosts:
        "${gitlab_hostname}":
          ansible_host: "${public_ip_gitlab}"
      vars:
        ansible_user:  ${ssh_user}
        ansible_ssh_private_key_file: ~/.ssh/id_rsa
        gitlab_external_url: "https://${gitlab_hostname}.${public_ip_gitlab}.${letsencrypt_domain}"
        gitlab_letsencrypt: yes
        gitlab_letsencrypt_contact_emails:
          - you.email@gmail.com
        gitlab_letsencrypt_group: root
        gitlab_letsencrypt_key_size: 2048
        gitlab_letsencrypt_owner: root
        gitlab_letsencrypt_wwwroot: /var/opt/gitlab/nginx/www
        gitlab_letsencrypt_auto_renew: yes
        gitlab_letsencrypt_auto_renew_hour: 0
        gitlab_letsencrypt_auto_renew_minute: nil
        gitlab_letsencrypt_auto_renew_day_of_month: 7
        gitlab_letsencrypy_auto_renew_log_directory: /var/log/gitlab/lets-encrypt

        gitlab_rails_ldap_enabled: yes
        gitlab_rails_ldap_servers:
          - name: main
            label: IPA
            host: "${freeipa_public_ip}"
            port: 389
            uid: 'uid'
            bind_dn: 'uid=gitlab_ldap_sync,cn=users,cn=accounts,dc=${freeipa_public_ip},dc=sslip,dc=io'
            password: "${pswd_gitlab_ldap_sync}"
            encryption: plain
            verify_certificates: no
            smartcard_auth: no
            active_directory: no
            allow_username_or_email_login: no
            lowercase_usernames: no
            block_auto_created_users: no
            base: 'cn=accounts,dc=${freeipa_public_ip},dc=sslip,dc=io'
            user_filter: ""
