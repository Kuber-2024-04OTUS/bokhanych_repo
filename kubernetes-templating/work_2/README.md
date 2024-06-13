``` 
# helmfile apply

Listing releases matching ^kafka-prod$
kafka-dev       dev             1               2024-05-29 10:46:59.320272982 +0300 +03 deployed        kafka-29.1.0    3.7.0      

kafka-prod      prod            1               2024-05-29 10:46:59.420219021 +0300 +03 deployed        kafka-29.1.0    3.7.0      


UPDATED RELEASES:
NAME         NAMESPACE   CHART           VERSION   DURATION
kafka-dev    dev         bitnami/kafka   29.1.0          7s
kafka-prod   prod        bitnami/kafka   29.1.0          7s
```

```
kubectl describe pods -n prod
Containers:
  kafka:
    Image:       docker.io/bitnami/kafka:3.5.2-debian-12-r17

kubectl describe pods -n dev
Containers:
  kafka:
    Image:       docker.io/bitnami/kafka:latest
```