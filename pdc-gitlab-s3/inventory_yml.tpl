all:
  children:
    primarydomaincontroller:
      hosts:
        "${pdc_hostname}":
          ansible_host: "${public_ip_pdc}"
      vars:
        ansible_user: Administrator
        ansible_password: "${windows_password}"
        ansible_connection: winrm
        ansible_port: 5986
        ansible_winrm_transport: basic
        ansible_winrm_server_cert_validation: ignore
        pdc_administrator_password: "${windows_password}"
        pdc_domain_safe_mode_password: "${windows_password}"
        pdc_domain: "${pdc_domain}"
        pdc_domain_path: "${pdc_domain_path}"
        pswd_gitlab_ldap_sync: "${pswd_gitlab_ldap_sync}"
        pswd_test_user_in_pdc: "${pswd_test_user_in_pdc}"
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

        gitlab_rails_backup_upload_connection:
          provider: AWS
          region: eu-west-1
          aws_access_key_id: "${aws_access_key_id}"
          aws_secret_access_key: "${aws_secret_access_key}"
          use_iam_profile: false
          endpoint: https://storage.yandexcloud.net
        gitlab_rails_backup_upload_remote_directory: "${gitlab_backup_bucket_name}"

        gitlab_rails_ldap_enabled: yes
        gitlab_rails_ldap_servers:
          - name: main
            label: LDAP
            host: "${public_ip_pdc}"
            port: 389
            uid: sAMAccountName
            bind_dn: CN=gitlab_ldap_sync,CN=Users,DC=ad,DC=domain,DC=test
            password: "${pswd_gitlab_ldap_sync}"
            encryption: plain
            verify_certificates: no
            smartcard_auth: no
            active_directory: yes
            allow_username_or_email_login: no
            lowercase_usernames: no
            block_auto_created_users: no
            base: "OU=GitlabUsers,DC=ad,DC=domain,DC=test"
            user_filter: ""
