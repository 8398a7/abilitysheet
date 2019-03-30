# k8s README

☆12参考表はhelm chartを提供しています。  
chartのデプロイは以下のコマンドで行なえます。

```bash
$ make helm-deploy
helm init --wait
$HELM_HOME has been configured at /Users/${username}/.helm.

Tiller (the Helm server-side component) has been installed into your Kubernetes Cluster.

Please note: by default, Tiller is deployed with an insecure 'allow unauthenticated users' policy.
To prevent this, run `helm init` with the --tiller-tls-verify flag.
For more information on securing your installation see: https://docs.helm.sh/using_helm/#securing-your-helm-installation
Happy Helming!
/Applications/Xcode.app/Contents/Developer/usr/bin/make helm-upgrade open-dashboard open-app
helm upgrade prod ./deployments/abilitysheet --install --wait --namespace abilitysheet
Release "prod" does not exist. Installing it now.
NAME:   prod
LAST DEPLOYED: Sun Mar 31 01:03:13 2019
NAMESPACE: abilitysheet
STATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME                           DATA  AGE
prod-abilitysheet-rails-env    18    36s
prod-nginx-ingress-controller  1     36s

==> v1/Deployment
NAME                       READY  UP-TO-DATE  AVAILABLE  AGE
prod-abilitysheet-puma     1/1    1           1          36s
prod-abilitysheet-redis    1/1    1           1          36s
prod-abilitysheet-sidekiq  1/1    1           1          36s

==> v1/PersistentVolume
NAME                     CAPACITY  ACCESS MODES  RECLAIM POLICY  STATUS  CLAIM                                 STORAGECLASS  REASON  AGE
prod-abilitysheet-redis  200Mi     RWO           Recycle         Bound   abilitysheet/prod-abilitysheet-redis  fast          36s

==> v1/PersistentVolumeClaim
NAME                     STATUS  VOLUME                   CAPACITY  ACCESS MODES  STORAGECLASS  AGE
prod-abilitysheet-redis  Bound   prod-abilitysheet-redis  200Mi     RWO           fast          36s

==> v1/Pod(related)
NAME                                                 READY  STATUS   RESTARTS  AGE
prod-abilitysheet-pg-0                               1/1    Running  0         36s
prod-abilitysheet-puma-6959c67c6c-r4j58              1/1    Running  0         36s
prod-abilitysheet-redis-6d6dd99bc9-8h8g5             1/1    Running  0         36s
prod-abilitysheet-sidekiq-75b555b5ff-jhh4q           1/1    Running  0         36s
prod-kubernetes-dashboard-5b88675bbf-v9gh9           1/1    Running  0         36s
prod-nginx-ingress-controller-9fdd8c4bc-bjwfp        1/1    Running  0         36s
prod-nginx-ingress-default-backend-785b8859c5-fsmdq  1/1    Running  0         36s

==> v1/Secret
NAME                         TYPE    DATA  AGE
prod-abilitysheet-pg         Opaque  1     36s
prod-abilitysheet-rails-env  Opaque  2     36s
prod-kubernetes-dashboard    Opaque  0     36s

==> v1/Service
NAME                                TYPE          CLUSTER-IP     EXTERNAL-IP  PORT(S)                     AGE
prod-abilitysheet-pg                ClusterIP     10.108.10.189  <none>       5432/TCP                    36s
prod-abilitysheet-puma              ClusterIP     10.109.131.6   <none>       3000/TCP                    36s
prod-abilitysheet-redis             ClusterIP     10.99.146.37   <none>       6379/TCP                    36s
prod-kubernetes-dashboard           ClusterIP     10.111.171.47  <none>       443/TCP                     36s
prod-nginx-ingress-controller       LoadBalancer  10.111.216.70  localhost    80:31286/TCP,443:32140/TCP  36s
prod-nginx-ingress-default-backend  ClusterIP     10.109.91.227  <none>       80/TCP                      36s

==> v1/ServiceAccount
NAME                       SECRETS  AGE
prod-kubernetes-dashboard  1        36s
prod-nginx-ingress         1        36s

==> v1/StatefulSet
NAME                  READY  AGE
prod-abilitysheet-pg  1/1    36s

==> v1beta1/ClusterRole
NAME                AGE
prod-nginx-ingress  36s

==> v1beta1/ClusterRoleBinding
NAME                AGE
prod-nginx-ingress  36s

==> v1beta1/Deployment
NAME                                READY  UP-TO-DATE  AVAILABLE  AGE
prod-kubernetes-dashboard           1/1    1           1          36s
prod-nginx-ingress-controller       1/1    1           1          36s
prod-nginx-ingress-default-backend  1/1    1           1          36s

==> v1beta1/Ingress
NAME          HOSTS                                            ADDRESS  PORTS  AGE
abilitysheet  app-127-0-0-1.nip.io,dashboard-127-0-0-1.nip.io  80, 443  36s

==> v1beta1/Role
NAME                       AGE
prod-kubernetes-dashboard  36s
prod-nginx-ingress         36s

==> v1beta1/RoleBinding
NAME                       AGE
prod-kubernetes-dashboard  36s
prod-nginx-ingress         36s
```

chartを更新したい場合は以下のコマンドを使ってください。

```bash
$ make helm-upgrade
helm upgrade prod ./deployments/abilitysheet --install --wait --namespace abilitysheet
Release "prod" has been upgraded. Happy Helming!
LAST DEPLOYED: Sun Mar 31 01:06:54 2019
NAMESPACE: abilitysheet
STATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME                           DATA  AGE
prod-abilitysheet-rails-env    18    3m44s
prod-nginx-ingress-controller  1     3m44s

==> v1/Deployment
NAME                       READY  UP-TO-DATE  AVAILABLE  AGE
prod-abilitysheet-puma     1/1    1           1          3m44s
prod-abilitysheet-redis    1/1    1           1          3m44s
prod-abilitysheet-sidekiq  1/1    1           1          3m44s

==> v1/PersistentVolume
NAME                     CAPACITY  ACCESS MODES  RECLAIM POLICY  STATUS  CLAIM                                 STORAGECLASS  REASON  AGE
prod-abilitysheet-redis  200Mi     RWO           Recycle         Bound   abilitysheet/prod-abilitysheet-redis  fast          3m44s

==> v1/PersistentVolumeClaim
NAME                     STATUS  VOLUME                   CAPACITY  ACCESS MODES  STORAGECLASS  AGE
prod-abilitysheet-redis  Bound   prod-abilitysheet-redis  200Mi     RWO           fast          3m44s

==> v1/Pod(related)
NAME                                                 READY  STATUS   RESTARTS  AGE
prod-abilitysheet-pg-0                               1/1    Running  0         3m44s
prod-abilitysheet-puma-6959c67c6c-r4j58              1/1    Running  0         3m44s
prod-abilitysheet-redis-6d6dd99bc9-8h8g5             1/1    Running  0         3m44s
prod-abilitysheet-sidekiq-75b555b5ff-jhh4q           1/1    Running  0         3m44s
prod-kubernetes-dashboard-5b88675bbf-v9gh9           1/1    Running  0         3m44s
prod-nginx-ingress-controller-9fdd8c4bc-bjwfp        1/1    Running  0         3m44s
prod-nginx-ingress-default-backend-785b8859c5-fsmdq  1/1    Running  0         3m44s

==> v1/Secret
NAME                         TYPE    DATA  AGE
prod-abilitysheet-pg         Opaque  1     3m44s
prod-abilitysheet-rails-env  Opaque  2     3m44s
prod-kubernetes-dashboard    Opaque  0     3m44s

==> v1/Service
NAME                                TYPE          CLUSTER-IP     EXTERNAL-IP  PORT(S)                     AGE
prod-abilitysheet-pg                ClusterIP     10.108.10.189  <none>       5432/TCP                    3m44s
prod-abilitysheet-puma              ClusterIP     10.109.131.6   <none>       3000/TCP                    3m44s
prod-abilitysheet-redis             ClusterIP     10.99.146.37   <none>       6379/TCP                    3m44s
prod-kubernetes-dashboard           ClusterIP     10.111.171.47  <none>       443/TCP                     3m44s
prod-nginx-ingress-controller       LoadBalancer  10.111.216.70  localhost    80:31286/TCP,443:32140/TCP  3m44s
prod-nginx-ingress-default-backend  ClusterIP     10.109.91.227  <none>       80/TCP                      3m44s

==> v1/ServiceAccount
NAME                       SECRETS  AGE
prod-kubernetes-dashboard  1        3m44s
prod-nginx-ingress         1        3m44s

==> v1/StatefulSet
NAME                  READY  AGE
prod-abilitysheet-pg  1/1    3m44s

==> v1beta1/ClusterRole
NAME                AGE
prod-nginx-ingress  3m44s

==> v1beta1/ClusterRoleBinding
NAME                AGE
prod-nginx-ingress  3m44s

==> v1beta1/Deployment
NAME                                READY  UP-TO-DATE  AVAILABLE  AGE
prod-kubernetes-dashboard           1/1    1           1          3m44s
prod-nginx-ingress-controller       1/1    1           1          3m44s
prod-nginx-ingress-default-backend  1/1    1           1          3m44s

==> v1beta1/Ingress
NAME          HOSTS                                            ADDRESS  PORTS  AGE
abilitysheet  app-127-0-0-1.nip.io,dashboard-127-0-0-1.nip.io  80, 443  3m44s

==> v1beta1/Role
NAME                       AGE
prod-kubernetes-dashboard  3m44s
prod-nginx-ingress         3m44s

==> v1beta1/RoleBinding
NAME                       AGE
prod-kubernetes-dashboard  3m44s
prod-nginx-ingress         3m44s
```
