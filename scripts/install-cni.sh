#!/bin/bash

install_cilium() {
    helm install cilium cilium/cilium --version 1.18.3 \
        --namespace kube-system --set operator.replicas=1    
}

install_calico() {
  kubectl create namespace tigera-operator
  helm install calico projectcalico/tigera-operator --version v3.31.0 --namespace tigera-operator \
  --set apiServer.enabled=false --set goldmane.enabled=false --set whisker.enabled=false
}



case "$1" in
    cilíum)
      install_cilium        
        ;;
    calico)
        install_calico
        ;;
    *)
        echo "Error: Invalid argument '$1'. Use 'cilium' or 'calico'."
        exit 1
        ;;
esac
