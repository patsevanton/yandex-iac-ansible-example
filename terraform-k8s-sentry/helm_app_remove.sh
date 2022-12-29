#!/bin/bash

set -eu pipefail

echo ""
echo "helm uninstall sentry"
helm uninstall sentry || true
