[victoria_storage]
%{~ for index, public_ip in vmstorage_public_ip }
vmstorage${index} ansible_host=${public_ip}
%{~ endfor }

[victoria_insert]
%{~ for index, public_ip in vminsert_public_ip }
vminsert${index} ansible_host=${public_ip}
%{~ endfor }

[victoria_select]
%{~ for index, public_ip in vmselect_private_ip }
vmselect${index} ansible_host=${public_ip}
%{~ endfor }

[victoria_storage:vars]
vm_role=victoria-storage

[victoria_insert:vars]
vm_role=victoria-insert

[victoria_select:vars]
vm_role=victoria-select

[load-balancer]
load-balancer-01

[victoria_cluster:children]
victoria_select
victoria_insert
victoria_storage

[all:vars]
ansible_user=${ ssh_user }
ansible_ssh_private_key_file=~/.ssh/id_rsa
vmstorage_group=victoria_cluster
