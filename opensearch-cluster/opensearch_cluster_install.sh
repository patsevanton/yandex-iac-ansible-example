#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")
TF_IN_AUTOMATION=1 terraform init -upgrade
unset HTTP_PROXY
unset HTTPS_PROXY
TF_IN_AUTOMATION=1 terraform apply -auto-approve
rm -rf opensearch-project || true
git clone https://github.com/opensearch-project/ansible-playbook.git opensearch-project
ansible-playbook -i host.ini opensearch-project/opensearch.yml --extra-vars "admin_password=Test@123 kibanaserver_password=Test@6789" --become
end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"
