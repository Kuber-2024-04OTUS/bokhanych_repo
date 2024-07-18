# CONSUL INSTALL:
```
kubectl create ns consul
helm repo add hashicorp https://helm.releases.hashicorp.com
helm search repo hashicorp/consul
helm pull hashicorp/consul --untar
helm install consul hashicorp/consul --set global.name=consul --create-namespace -n consul -f consul/values.yaml
```

# VAULT INSTALL:
```
kubectl create ns vault
helm repo add hashicorp https://helm.releases.hashicorp.com
helm pull hashicorp/vault --untar
helm install vault hashicorp/vault --create-namespace -n vault -f vault/values.yaml
```

# VAULT INIT AND UNSEAL:
```
kubectl exec -it vault-0 -n vault -- vault operator init
kubectl exec -it vault-0 -n vault -- vault operator unseal

kubectl exec -it vault-1 -n vault -- vault operator init
kubectl exec -it vault-1 -n vault -- vault operator unseal

kubectl exec -it vault-2 -n vault -- vault operator init
kubectl exec -it vault-2 -n vault -- vault operator unseal
```

# SECRET ENGINE:
```
vault secrets enable -path=otus kv
```