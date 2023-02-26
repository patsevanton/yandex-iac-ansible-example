#!/bin/bash

echo ""


helmfile destroy --skip-deps --skip-charts -f helmfile-postgresql.yaml
#kubectl delete namespace postgresql || true
#kubectl delete namespace ingress-nginx|| true
#rm -f "/home/$USER/.kube/config"
