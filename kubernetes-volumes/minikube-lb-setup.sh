#!/bin/bash
cd /tmp

# KUBECTL:
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
sudo apt-get update
sudo apt-get install -y kubectl
echo 'source /etc/bash_completion' >>~/.bashrc
echo 'source <(kubectl completion bash)' >>~/.bashrc
source ~/.bashrc

# DOCKER:
wget https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/containerd.io_1.6.31-1_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/docker-ce_26.1.3-1~ubuntu.22.04~jammy_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/docker-ce-cli_26.1.3-1~ubuntu.22.04~jammy_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/docker-buildx-plugin_0.14.0-1~ubuntu.22.04~jammy_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/amd64/docker-compose-plugin_2.6.0~ubuntu-jammy_amd64.deb
sudo dpkg -i ./containerd.io_1.6.31-1_amd64.deb
sudo dpkg -i ./docker-ce-cli_26.1.3-1~ubuntu.22.04~jammy_amd64.deb
sudo dpkg -i ./docker-ce_26.1.3-1~ubuntu.22.04~jammy_amd64.deb
sudo dpkg -i ./docker-buildx-plugin_0.14.0-1~ubuntu.22.04~jammy_amd64.deb
sudo dpkg -i ./docker-compose-plugin_2.6.0~ubuntu-jammy_amd64.deb
sudo service docker start

# MINIKUBE:
wget https://github.com/kubernetes/minikube/releases/download/v1.33.1/minikube_1.33.1-0_amd64.deb
sudo dpkg -i ./minikube_1.33.1-0_amd64.deb
minikube version
sudo apt -y install conntrack
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.30.0/crictl-v1.30.0-linux-amd64.tar.gz
sudo tar zxvf crictl-v1.30.0-linux-amd64.tar.gz -C /usr/local/bin
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.14/cri-dockerd_0.3.14.3-0.ubuntu-jammy_amd64.deb
sudo dpkg -i ./cri-dockerd_0.3.14.3-0.ubuntu-jammy_amd64.deb
wget https://github.com/containernetworking/plugins/releases/download/v1.5.0/cni-plugins-linux-amd64-v1.5.0.tgz
sudo mkdir -p /opt/cni/bin
sudo tar -xf cni-plugins-linux-amd64-v1.5.0.tgz -C /opt/cni/bin
sudo mkdir -p /etc/cni/net.d
minikube start --vm-driver=none


# # FIX ERROR:
# sed -i "s/cgroupDriver: systemd/cgroupDriver: cgroupfs/g" /var/lib/kubelet/config.yaml
# systemctl daemon-reload
# systemctl restart kubelet
# /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# K9S:
sudo apt install snapd
sudo snap install k9s
sudo ln -s /snap/k9s/current/bin/k9s /snap/bin/

# CONFIGURE metallb loadbalancer:
https://kubebyexample.com/learning-paths/metallb/install