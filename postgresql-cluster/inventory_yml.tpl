all:
  children:
    vmstorage:
      hosts:
        vmstorage01:
          ansible_host: "${public_ip_vmstorage01}"
        vmstorage02:
          ansible_host: "${public_ip_vmstorage02}"
        vmstorage03:
          ansible_host: "${public_ip_vmstorage03}"
        vmstorage04:
          ansible_host: "${public_ip_vmstorage04}"
    vminsert:
      hosts:
        vminsert01:
          ansible_host: "${public_ip_vminsert01}"
        vminsert02:
          ansible_host: "${public_ip_vminsert02}"
    vmselect:
      hosts:
        vmselect01:
          ansible_host: "${public_ip_vmselect01}"
        vmselect02:
          ansible_host: "${public_ip_vmselect02}"

  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
