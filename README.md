**ЗАПУСК И ПРОВЕРКА ДЕПЛОЙМЕНТА**
```
# kubectl apply -f namespaces.yaml && kubectl apply -f configmaps.yaml && kubectl apply -f deployments.yaml && kubectl apply -f services.yaml && kubectl apply -f ingress.yaml
namespace/homework created
configmap/nginx-conf created
deployment.apps/web-server-deployment created
service/web-server-service created
ingress.networking.k8s.io/main-ingress created
```

kubectl apply -f namespaces.yaml && kubectl apply -f configmaps.yaml && kubectl apply -f deployments.yaml && kubectl apply -f services.yaml && kubectl apply -f ingress.yaml

**ПРОВЕРКА ПРИЛОЖЕНИЯ**
```
# curl homework.otus/homepage
Testpage ;)
# curl homework.otus
Testpage ;)
# curl homework.otus/index.html
<html>
<head><title>301 Moved Permanently</title></head>
<body>
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx/1.19.0</center>
</body>
</html>
```


**ОЧИСТКА**
```
kubectl delete namespaces homework
```
# При удалении namespace так же удаляется configmap, deployment, service, ingress.