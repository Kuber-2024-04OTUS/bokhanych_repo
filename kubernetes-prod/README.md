● Для выполнения данного задания вам потребуется создать минимум 4 виртуальных машины в YC следующей конфигурации:
Для master - 1 узел, 2vCPU, 8GB RAM, для worker – 3 узла, 2vCPU, 8GB RAM

● Версия создаваемого кластера должна быть на одну ниже чем актуальная версия kubernetes на момент выполнения (т.е если последняя актуальная версия 1.30.x, то ставим 1.29.x)

● Выполните подготовительные работы на узлах в соответствии с инструкцией (отключить swap, включите маршрутизацию и т.д)

● Установите containerd, kubeadm, kubelet, kubectl на все ВМ

● Выполните kubeadm init на мастер-ноде

● Установите Flannel в качестве сетевого плагина

● Выполните kubeadm join на воркер нодах

● Приложите к результатам ДЗ вывод команды kubectl get nodes -o wide, показывающий статус и версию k8s всех нод кластера

● Приложите к результатам ДЗ все команды, выполненные вами как на мастер, так и на воркер нодах (можно в readme, можно в виде .sh скриптов, или иным образом как вам удобно) для возможности воспроизведения ваших действий

● Выполните обновление master ноды до последней актуальной версии k8s с помощья kubeadm

● Последовательно выведите из планирования все воркер-ноды, обновите их до последней актуальной версии и верните в планирование

● Приложите к результатам ДЗ все команды по обновления версии кластера, аналогично как вы делали ÿто для команд установки

● Приложите к результатам ДЗ вывод команды kubectl get nodes -o wide, показываящий статус и версия k8s всех нод кластера после обновления


***Подготовка мастера:***
```
sed -i "s%/swap.img%#/swap.img%g" /etc/fstab

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gpg -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
 
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
apt-get install containerd.io -y

mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install kubelet kubeadm kubectl -y
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

sudo sh -c "containerd config default > /etc/containerd/config.toml"
sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd.service
```

***Инициализация кластера:***
```
# CLUSTER INIT:
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.10.21.43:6443 --token fhv3ak.2qe6dwi2alkknwl4 \
        --discovery-token-ca-cert-hash sha256:7f2cb91ab5ec31bd288c6c7cd963535a654d39e910194e7947c63f0858e56715

kubectl get nodes
NAME              STATUS   ROLES           AGE     VERSION
k8s-bokhanych-1   Ready    control-plane   4m52s   v1.29.7
```

***Обновление нод кластера до последней версии:***
```
root@k8s-bokhanych-1:~# kubectl get nodes
NAME              STATUS     ROLES           AGE     VERSION
k8s-bokhanych-1   NotReady   control-plane   4h3m    v1.30.3
k8s-bokhanych-2   Ready      <none>          3h55m   v1.29.7
k8s-bokhanych-3   Ready      <none>          3h54m   v1.29.7
k8s-bokhanych-4   Ready      <none>          3h54m   v1.29.7

# CLUSTER UPDATE (запустить на каждой ноде):
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" >> /etc/apt/sources.list.d/kubernetes.list

sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm=1.30.3-1.1 && \
sudo apt-mark hold kubeadm

sudo apt-mark unhold kubelet && \
sudo apt update -y && sudo apt upgrade -y && \
sudo apt-mark hold kubelet
```

***Результат:***
```
root@k8s-bokhanych-1:~# kubectl get nodes
NAME              STATUS   ROLES           AGE     VERSION
k8s-bokhanych-1   Ready    control-plane   4h14m   v1.30.3
k8s-bokhanych-2   Ready    <none>          4h6m    v1.30.3
k8s-bokhanych-3   Ready    <none>          4h5m    v1.30.3
k8s-bokhanych-4   Ready    <none>          4h5m    v1.30.3
```
