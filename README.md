** СТАВИМ МЕТКУ НА НОДУ **
```
root@k8s-minikube:~# kubectl label nodes minikube homework=true
node/minikube labeled
```
```
root@k8s-minikube:~# kubectl get nodes --show-labels
NAME       STATUS   ROLES           AGE   VERSION   LABELS
minikube   Ready    control-plane   9d    v1.30.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,homework=true,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube,kubernetes.io/os=linux,minikube.k8s.io/commit=86fc9d54fca63f295d8737c8eacdbb7987e89c67,minikube.k8s.io/name=minikube,minikube.k8s.io/primary=true,minikube.k8s.io/updated_at=2024_05_04T11_41_10_0700,minikube.k8s.io/version=v1.33.0,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
```
** ЗАПУСК И ПРОВЕРКА ДЕПЛОЙМЕНТА **
```
root@k8s-minikube:/opt/bokhanych_repo# kubectl apply -f namespaces.yaml
namespace/homework created
```
```
root@k8s-minikube:/opt/bokhanych_repo# kubectl apply -f configmaps.yaml
configmap/nginx-conf created
```
```
root@k8s-minikube:/opt/bokhanych_repo# kubectl apply -f deployments.yaml
deployment.apps/web-server-deployment created
```
```
root@k8s-minikube:/opt/bokhanych_repo# kubectl apply -f services.yaml
service/web-server-service created
```
```
root@k8s-minikube:/opt/bokhanych_repo# kubectl get pod
NAME                                     READY   STATUS     RESTARTS   AGE
web-server-deployment-65bdcc78f7-4zr88   0/1     Init:0/1   0          3s
web-server-deployment-65bdcc78f7-cr6v5   0/1     Init:0/1   0          3s
web-server-deployment-65bdcc78f7-rjqx7   0/1     Init:0/1   0          3s
```
```
root@k8s-minikube:/opt/bokhanych_repo# kubectl get pod
NAME                                     READY   STATUS    RESTARTS   AGE
web-server-deployment-65bdcc78f7-4zr88   1/1     Running   0          17s
web-server-deployment-65bdcc78f7-cr6v5   1/1     Running   0          17s
web-server-deployment-65bdcc78f7-rjqx7   1/1     Running   0          17s
```
** ПРОВЕРКА ПРИЛОЖЕНИЯ *в будущем допилю просмотр веб страницы с браузера* **
```
root@k8s-minikube:/opt/bokhanych_repo# kubectl get svc
NAME                 TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
web-server-service   NodePort   10.102.113.15   <none>        80:30418/TCP   4s
```
```
root@k8s-minikube:/opt/bokhanych_repo# minikube service web-server-service --url -n homework
http://192.168.49.2:30418
```
```
root@k8s-minikube:/opt/bokhanych_repo# minikube ssh

docker@minikube:~$ curl http://192.168.49.2:30418
Testpage ;)
```

** ПРОВЕРКА RollingUpdate **
```
root@k8s-minikube:/opt/bokhanych_repo# kubectl apply -f deployments.yaml
deployment.apps/web-server-deployment configured
```
```
root@k8s-minikube:/opt/bokhanych_repo# kubectl get pod
NAME                                     READY   STATUS            RESTARTS   AGE
web-server-deployment-65bdcc78f7-4zr88   1/1     Running           0          16m
web-server-deployment-65bdcc78f7-rjqx7   1/1     Running           0          16m
web-server-deployment-78799cb949-9rxmw   0/1     Pending           0          7s
web-server-deployment-78799cb949-ttgsm   0/1     PodInitializing   0          7s
```
```
root@k8s-minikube:/opt/bokhanych_repo# kubectl get pod
NAME                                     READY   STATUS     RESTARTS   AGE
web-server-deployment-65bdcc78f7-4zr88   1/1     Running    0          16m
web-server-deployment-78799cb949-2tbbx   0/1     Pending    0          3s
web-server-deployment-78799cb949-9rxmw   0/1     Init:0/1   0          20s
web-server-deployment-78799cb949-ttgsm   1/1     Running    0          20s
```
```
root@k8s-minikube:/opt/bokhanych_repo# kubectl get pod
NAME                                     READY   STATUS     RESTARTS   AGE
web-server-deployment-78799cb949-2tbbx   0/1     Init:0/1   0          14s
web-server-deployment-78799cb949-9rxmw   1/1     Running    0          31s
web-server-deployment-78799cb949-ttgsm   1/1     Running    0          31s
```
```
root@k8s-minikube:/opt/bokhanych_repo# kubectl get pod
NAME                                     READY   STATUS    RESTARTS   AGE
web-server-deployment-78799cb949-2tbbx   1/1     Running   0          25s
web-server-deployment-78799cb949-9rxmw   1/1     Running   0          42s
web-server-deployment-78799cb949-ttgsm   1/1     Running   0          42s
```