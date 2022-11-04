#!/bin/bash

set -eu pipefail

start_time=`date +%s`
date1=$(date +"%s")

# Check command available yc terraform kubectl helm
list_command_available=(yc terraform kubectl helm)

for i in ${list_command_available[*]}
do
    if ! command -v $i &> /dev/null
    then
        echo "$i could not be found"
        exit 1
    fi
done

if yc config list | grep -q 'token'; then
  echo "yc configured. Passed"
else
  echo "yc doesn't configured."
  echo "Please run 'yc init'"
  exit 1
fi

TF_IN_AUTOMATION=1 terraform init -upgrade
TF_IN_AUTOMATION=1 terraform apply -auto-approve
mkdir -p /home/$USER/.kube
terraform output kubeconfig > /home/$USER/.kube/config
sed '/EOT/d' -i /home/$USER/.kube/config

end_time=`date +%s`
date2=$(date +"%s")
echo "###############"
echo Execution time was `expr $end_time - $start_time` s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"