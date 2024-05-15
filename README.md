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
**ПРОВЕРКА ПРИЛОЖЕНИЯ**
```
root@k8s-minikube:/opt/bokhanych_repo# curl homework.otus
Testpage ;)
root@k8s-minikube:/opt/bokhanych_repo# curl homework.otus/index.html
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.19.0</center>
</body>
</html>
root@k8s-minikube:/opt/bokhanych_repo# curl homework.otus/homepage
Testpage ;)
```