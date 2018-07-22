# abilitysheet k8s README

## minikube

最初にk8sクラスタの作成します。

```bash
minikube start --vm-driver=hyperkit
minikube addons enable ingress
# 状況監視
minikube dashboard
```

次に必要なミドルウェアのコンテナを立てます。<br>
nginxの設定に関しては各環境で異なる可能性が大きいです。<br>
nip.ioベースで `minikube ip` で確認できるIPに修正してください<br>
また、 `nginx/secret.yaml` にSSL証明書の準備が必要です。

```bash
kubectl apply -f postgres
kubectl apply -f redis
kubectl apply -f nginx
```

準備が整ったらdbの準備を行っていきます。<br>
1つずつ順番に実行してください。<br>
`db-create.yaml` は初回のためimage pullに時間がかかります。<br>

```bash
kubectl apply -f rails/secret.yaml
kubectl apply -f rails/jobs/db-create.yaml
kubectl apply -f rails/jobs/db-migrate.yaml
kubectl apply -f rails/jobs/db-seed.yaml
kubectl delete -f rails/jobs
```

dbの準備が整ったらrailsのコンテナを立てます。

```bash
kubectl apply -f rails
```

動作確認は以下のコマンドからできます。

```bash
open https://abilitysheet.$(minikube ip).nip.io
```
