#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")
TF_IN_AUTOMATION=1 terraform init -upgrade
unset HTTP_PROXY
unset HTTPS_PROXY
TF_IN_AUTOMATION=1 terraform apply -auto-approve
pip3 install -U --user Jinja2
ansible-galaxy install systemli.letsencrypt
ansible-galaxy install geerlingguy.nginx
ansible-galaxy install patrickjahns.promtail
ansible-galaxy install andrewrothstein.prometheus_jmx_exporter
ansible-galaxy install buluma.grafana
ansible-galaxy install geerlingguy.docker
ansible-galaxy install --force git+https://github.com/virtUOS/ansible-loki.git,main
ansible-playbook -i inventory.yml playbook.yml
end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo "Execution time was $(( end_time - start_time )) s."
DIFF=$(( date2 - date1 ))
echo "Duration: $(( DIFF / 3600 )) hours $((( DIFF % 3600) / 60 )) minutes $(( DIFF % 60 )) seconds"
echo "###############"
