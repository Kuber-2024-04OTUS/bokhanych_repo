4. Пошаговая инструкция выполнения домашнего задания

● Необходимо создать кастомный образ nginx, отдающий свои метрики на определенном endpoint 
(пример из офф документации в разделе ссылок)

● Установить в кластер Prometheus-operator любым удобным вам способом 
(рекомендуется ставить или по ссылке из офф документации, либо через helm-чарт)

● Создать deployment запускающий ваш кастомный nginx образ и service для него

● Настроить запуск nginx prometheus exporter 
(отдельным подом или в составе пода с nginx – не принципиально) и сконфигурировать его для сбора метрик с nginx

● Создать манифест serviceMonitor, описывающий сбор метрик с подов, которые вы создали


Project links: 
```
    http://monitoring.homework
    http://homework.otus
    http://homework.otus/basic_status
```
For /etc/hosts:
```
    157.90.28.247 monitoring.homework
    157.90.28.247 homework.otus
```

```
root@k8s-minikube:/opt/bokhanych_repo/kubernetes-monitoring# kubectl apply -f 1_namespaces.yaml 
namespace/prometheus created
root@k8s-minikube:/opt/bokhanych_repo/kubernetes-monitoring# kubectl apply -f 2_nginx-configmap.yaml 
configmap/nginx-conf created
root@k8s-minikube:/opt/bokhanych_repo/kubernetes-monitoring# kubectl apply -f 3_deployments.yaml 
deployment.apps/web-server-deployment created
deployment.apps/nginx-prometheus-exporter-deployment created
root@k8s-minikube:/opt/bokhanych_repo/kubernetes-monitoring# kubectl apply -f 4_services.yaml 
service/web-server-service created
service/nginx-prometheus-exporter-monitor-service created
root@k8s-minikube:/opt/bokhanych_repo/kubernetes-monitoring# kubectl apply -f 5_ingress.yaml 
ingress.networking.k8s.io/prometheus-ingress created
root@k8s-minikube:/opt/bokhanych_repo/kubernetes-monitoring# kubectl apply -f 6_service-monitor.yaml 
servicemonitor.monitoring.coreos.com/nginx-prometheus-exporter-monitor created


root@k8s-minikube:/tmp# curl homework.otus/basic_status
Active connections: 1
server accepts handled requests
 2 2 2
Reading: 0 Writing: 1 Waiting: 0

root@k8s-minikube:/tmp# curl homework.otus
Testpage ;)

root@k8s-minikube:/tmp# curl monitoring.homework
<a href="/graph">Found</a>.


```

kube-prometheus
https://artifacthub.io/packages/helm/bitnami/kube-prometheus?modal=install

```
root@k8s-minikube:/opt/bokhanych_repo/kubernetes-monitoring# helm install my-kube-prometheus bitnami/kube-prometheus -n prometheus 
NAME: my-kube-prometheus
LAST DEPLOYED: Tue Jun 11 10:08:51 2024
NAMESPACE: prometheus
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: kube-prometheus
CHART VERSION: 9.5.0
APP VERSION: 0.74.0
```


![exporter-monitor](image.png)