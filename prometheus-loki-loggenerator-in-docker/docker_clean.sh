#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")
ansible-playbook -i inventory.yml docker_clean.yml
end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"
