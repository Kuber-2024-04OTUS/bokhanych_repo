**ЗАПУСК И ПРОВЕРКА**
```
kubectl apply -f 1_namespace.yaml \
&& kubectl apply -f 2_cm.yaml \
&& kubectl apply -f 3_storageclass.yaml \
&& kubectl apply -f 4_pvc.yaml \
&& kubectl apply -f 5_deployment.yaml \
&& kubectl apply -f 6_service.yaml \
&& kubectl apply -f 7_ingress.yaml 

namespace/homework created
configmap/bokhanych-configmap created
configmap/nginx-conf created
storageclass.storage.k8s.io/bokhanych-storageclass created
persistentvolumeclaim/bokhanych-pvc created
deployment.apps/web-server-deployment created
service/web-server-service created
ingress.networking.k8s.io/main-ingress created

# curl homework.otus
Testpage ;)

# curl homework.otus/conf/index.html
Welcome to bokhanych-configmap!

# kubectl get storageclasses.storage.k8s.io
NAME                     PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
bokhanych-storageclass   k8s.io/minikube-hostpath   Retain          Immediate           false                  15m
```

**ОЧИСТКА**
```
kubectl delete namespaces homework
kubectl delete storageclasses bokhanych-storageclass
```
# При удалении namespace так же удаляется configmap, deployment, service, ingress.