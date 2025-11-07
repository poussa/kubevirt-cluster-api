#!/bin/bash

POD_CIDR="${POD_CIDR:-10.0.0.0/8}" # change this if your host is overlapping CIDR

install_cilium() {
    helm install cilium cilium/cilium --version 1.18.3 \
        --namespace kube-system --set operator.replicas=1 \
        --set ipam.operator.clusterPoolIPv4PodCIDRList=${POD_CIDR}
}

install_cilium        
