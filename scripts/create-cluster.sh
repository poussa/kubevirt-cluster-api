#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

NODENAME=$(hostname -s | tr '[:upper:]' '[:lower:]')
CONFIG_FILE="${SCRIPT_DIR}/cluster-config.yaml"

sudo -E kubeadm init --node-name $NODENAME --config=${CONFIG_FILE}

mkdir -p $HOME/.kube
sudo cat /etc/kubernetes/admin.conf | tee $HOME/.kube/config > /dev/null
