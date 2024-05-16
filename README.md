**ЗАПУСК И ПРОВЕРКА ДЕПЛОЙМЕНТА**
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
root@k8s-minikube:/opt/bokhanych_repo# kubectl apply -f ingress.yaml
ingress.networking.k8s.io/main-ingress created
ingress.networking.k8s.io/rewrite-ingress created
```

kubectl apply -f namespaces.yaml && kubectl apply -f configmaps.yaml && kubectl apply -f deployments.yaml && kubectl apply -f services.yaml && kubectl apply -f ingress.yaml

**ПРОВЕРКА ПРИЛОЖЕНИЯ**
```
root@k8s-minikube:/opt/bokhanych_repo# curl homework.otus/homepage
Testpage ;)
root@k8s-minikube:/opt/bokhanych_repo# curl homework.otus
Testpage ;)
root@k8s-minikube:/opt/bokhanych_repo# curl homework.otus/index.html
<html>
<head><title>301 Moved Permanently</title></head>
<body>
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx/1.19.0</center>
</body>
</html>

```