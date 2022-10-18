# ## Configure 'ip' variable to bind kubernetes services on a
# ## different ip than the default iface
# ## We should set etcd_member_name for etcd cluster. The node that is not a etcd member do not need to set the value, or can set the empty string value.
[all]
%{ for index, hostname in hostnames ~}
${hostname} ansible_host=${kubespray_public_ip["${index}"]} ip=${kubespray_private_ip["${index}"]}
%{ endfor ~}

[kube_control_plane]
%{ for index, hostname in hostnames ~}
${hostname}
%{ endfor ~}

[etcd]
%{ for index, hostname in hostnames ~}
${hostname}
%{ endfor ~}

[kube_node]
%{ for index, hostname in hostnames ~}
${hostname}
%{ endfor ~}

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr

# Connection settings
[all:vars]
ansible_user=${ssh_user}
ansible_ssh_private_key_file=~/.ssh/id_rsa
