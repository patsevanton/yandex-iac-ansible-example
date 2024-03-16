#!/bin/bash

echo ""

helmfile destroy -f helmfile-promtail.yaml

rm -f "/home/$USER/.kube/config"
