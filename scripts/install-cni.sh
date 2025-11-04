#!/bin/bash

POD_CIDR="11.0.0.0/24"

install_cilium() {
    helm install cilium cilium/cilium --version 1.18.3 \
        --namespace kube-system --set operator.replicas=1 \
        --set ipam.operator.clusterPoolIPv4PodCIDRList=${POD_CIDR}
}

install_cilium        
