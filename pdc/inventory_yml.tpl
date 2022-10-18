all:
  children:
    windows:
      hosts:
        "${pdc_hostname}":
          ansible_host: "${public_ip}"
  vars:
    ansible_user: Administrator
    ansible_password: "${pdc_admin_password}"
    ansible_connection: winrm
    ansible_port: 5986
    ansible_winrm_transport: basic
    ansible_winrm_server_cert_validation: ignore
    pdc_administrator_password: "${pdc_admin_password}"
    pdc_domain: "${pdc_domain}"
    pdc_domain_path: "${pdc_domain_path}"
    ssl_cert_subject: freeipa.domain.test
    cert_ca_config_name: pdc.domain.test\RootCA
    certificate_template_name: SubCA
    pfx_password: "${pfx_password}"
