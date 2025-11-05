

sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab


cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

# Add proxy configuration if https_proxy is set
if [ -n "$https_proxy" ] ; then
    sudo mkdir -p /etc/systemd/system/containerd.service.d
    sudo bash -c 'cat << EOF > /etc/systemd/system/containerd.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=$https_proxy"
Environment="HTTPS_PROXY=$https_proxy"
Environment="NO_PROXY=127.0.0.1,localhost,::1,.svc,.svc.cluster.local,10.0.0.0/8,192.168.0.0/16"
EOF'
    sudo systemctl daemon-reload
    sudo systemctl restart containerd
fi
