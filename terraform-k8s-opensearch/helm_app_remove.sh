#!/bin/bash

set -eu pipefail

echo ""
echo "helm uninstall opensearch"
helm uninstall opensearch || true
