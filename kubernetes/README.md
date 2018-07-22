# abilitysheet k8s README

## minikube

最初にk8sクラスタの作成します。

```bash
minikube start --vm-driver=hyperkit
# 状況監視
minikube dashboard
```

次に必要なミドルウェアのコンテナを立てます。

```bash
kubectl apply -f postgres
kubectl apply -f redis
```

準備が整ったらdbの準備を行っていきます。
1つずつ順番に実行してください。
`db-create.yaml` は初回のためimage pullに時間がかかります。

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
open $(minikube service rails-service --url)
```
