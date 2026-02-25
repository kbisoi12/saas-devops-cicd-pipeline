#!/usr/bin/env bash
set -euo pipefail

CHART_PATH="${1:-../saas-kubernetes-deployment/helm/saas-app}"

echo "Installing helm..."
curl -sSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash >/dev/null

echo "Render helm templates..."
helm template saas "$CHART_PATH" > rendered.yaml

echo "Installing kubeconform..."
curl -sSL -o kubeconform.tar.gz https://github.com/yannh/kubeconform/releases/latest/download/kubeconform-linux-amd64.tar.gz
tar -xzf kubeconform.tar.gz kubeconform
sudo mv kubeconform /usr/local/bin/kubeconform

echo "Schema-validate rendered manifests..."
kubeconform -strict -summary -ignore-missing-schemas rendered.yaml
echo "Helm render + validation OK"