#!/bin/bash
sudo su <<EOF
cd
apt-get update
apt-get install git -y
apt-get install -y open-iscsi
sleep 30
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
apt-get install jq -y
curl https://raw.githubusercontent.com/longhorn/longhorn/v1.1.2/scripts/environment_check.sh | sudo bash
cp -arv /etc/rancher/k3s/k3s.yaml ./
chmod 777 /etc/rancher/k3s/k3s.yaml
export KUBECONFIG=./k3s.yaml
helm repo add longhorn https://charts.longhorn.io
helm repo update
kubectl create namespace longhorn-system
helm upgrade -i longhorn longhorn/longhorn --namespace longhorn-system
<<EOF
