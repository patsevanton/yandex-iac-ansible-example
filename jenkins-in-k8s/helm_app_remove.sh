#!/bin/bash

set -eu pipefail

# uninstall Jenkins
echo ""
echo "werf helm uninstall jenkins"
werf helm uninstall jenkins || true
