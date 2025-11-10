#!/bin/bash

set -euo pipefail

# Script variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

# Function to handle errors
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

install_kubevirt() {
    export VERSION=$(curl -s https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt)
    log "Installing KubeVirt $VERSION"
    kubectl create -f "https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-operator.yaml"
    kubectl create -f "https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-cr.yaml"
}

uninstall_kubevirt() {
    export VERSION=$(curl -s https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt)
    log "Uninstalling KubeVirt $VERSION"
    kubectl delete -f "https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-cr.yaml" --ignore-not-found
    kubectl delete -f "https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/kubevirt-operator.yaml" --ignore-not-found
}

install_kubevirt_provider() {
    log "Installing KubeVirt provider"
    clusterctl init --infrastructure kubevirt
}

# Main installation function
main() {
    if [[ "${1:-}" == "uninstall" ]]; then
        log "Starting uninstallation..."
        uninstall_kubevirt
        log "Uninstallation completed successfully"
    else
        log "Starting installation..."
        install_kubevirt
        install_kubevirt_provider
        log "Installation completed successfully"
    fi
}

# Run main function
main "$@"