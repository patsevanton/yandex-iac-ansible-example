#!/bin/bash

set -eu pipefail

start_time=$(date +%s)
date1=$(date +"%s")

# Получение External IP (внешнего IP) Kubernetes сервиса nginx-ingress-ingress-nginx-controller
echo ""
echo "Get External IP:"
export external_ip=$(kubectl get services nginx-ingress-ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
export jenkins_url=jenkins.$external_ip.sslip.io
echo ""
echo "jenkins_url:"
echo $jenkins_url

# Install Jenkins
echo ""
echo "Install Jenkins"
helm repo add jenkins https://charts.jenkins.io
helm repo update
# werf helm upgrade --install --atomic jenkins --set controller.ingress.hostName=$jenkins_url,controller.ingress.tls[0].hosts=$jenkins_url -f jenkins-values.yaml jenkins/jenkins
werf helm upgrade --install --atomic jenkins -f jenkins-values-minimal.yaml jenkins/jenkins
echo ""
echo "Print jenkins password"
kubectl exec --namespace default -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo

end_time=$(date +%s)
date2=$(date +"%s")
echo "###############"
echo Execution time was $(expr $end_time - $start_time)  s.
DIFF=$(($date2-$date1))
echo "Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
echo "###############"