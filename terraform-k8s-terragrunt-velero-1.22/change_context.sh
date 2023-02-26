#!/bin/bash

mkdir -p "/home/$USER/.kube"
cd master
export cluster_id=$(terragrunt output --raw cluster_id)
echo "$cluster_id"
cd ..
yc managed-kubernetes cluster get-credentials --id "$cluster_id" --external --force
