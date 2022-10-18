all:
  children:
    primarydomaincontroller:
      hosts:
        "${pdc_hostname}":
          ansible_host: "${public_ip_pdc}"
      vars:
        ansible_user: Administrator
        ansible_password: "${pdc_admin_password}"
        ansible_connection: winrm
        ansible_port: 5986
        ansible_winrm_transport: basic
        ansible_winrm_server_cert_validation: ignore
        pdc_administrator_password: "${pdc_admin_password}"
        pdc_domain_safe_mode_password: "${pdc_admin_password}"
        pdc_domain: "${pdc_domain}"
        pdc_domain_path: "${pdc_domain_path}"
        pswd_freeipa_ldap_sync: "${pswd_freeipa_ldap_sync}"
        pswd_test_user_in_pdc: "${pswd_test_user_in_pdc}"
