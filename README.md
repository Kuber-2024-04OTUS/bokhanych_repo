**ЗАПУСК И ПРОВЕРКА ДЕПЛОЙМЕНТА**
```
kubectl apply -f 1_namespace.yaml //
&& kubectl apply -f 2_cm.yaml //
&& kubectl apply -f 3_storageclass.yaml //
&& kubectl apply -f 4_pvc.yaml //
&& kubectl apply -f 5_deployment.yaml //
&& kubectl apply -f 6_service.yaml //
&& kubectl apply -f 7_ingress.yaml 

```

**ПРОВЕРКА ПРИЛОЖЕНИЯ**
```
# curl homework.otus/homepage
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
# curl homework.otus
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
# curl homework.otus/index.html       -> http://homework.otus/index.html редиректит на http://homework.otus/homepage
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