#!/bin/bash

# if running on single node cluster, remove the labels below:
# kubectl label <master> node.kubernetes.io/exclude-from-external-load-balancers-

set -euo pipefail

# Script variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

install_metallb() {
    METALLB_VER=$(curl -s "https://api.github.com/repos/metallb/metallb/releases/latest" | jq -r ".tag_name")
    kubectl apply -f "https://raw.githubusercontent.com/metallb/metallb/${METALLB_VER}/config/manifests/metallb-native.yaml"
}

uninstall_metallb() {
    METALLB_VER=$(curl -s "https://api.github.com/repos/metallb/metallb/releases/latest" | jq -r ".tag_name")
    kubectl delete -f "https://raw.githubusercontent.com/metallb/metallb/${METALLB_VER}/config/manifests/metallb-native.yaml" --ignore-not-found
}

# Main installation function
main() {
    if [[ "${1:-}" == "uninstall" ]]; then
        log "Starting uninstallation..."
        uninstall_metallb
        log "Uninstallation completed successfully"
    else
        log "Starting installation..."
        install_metallb
        log "Installation completed successfully"
    fi
}

# Run main function
main "$@"