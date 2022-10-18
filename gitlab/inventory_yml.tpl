all:
  children:
    gitlab:
      hosts:
        "${gitlab_hostname}":
          ansible_host: "${public_ip}"
  vars:
    gitlab_external_url: "https://${gitlab_hostname}.${public_ip}.${domain}"
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
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
    gitlab_initial_root_password: true
