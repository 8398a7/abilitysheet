deploy-dashboard:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
	open http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
	kubectl proxy
deploy-ingress:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
deploy-middleware:
	kubectl apply -f ./deployments/ns.yaml
	kubectl apply -f ./deployments/postgresql
	kubectl apply -f ./deployments/redis
	kubectl apply -f ./deployments/nginx
deploy-db:
	kubectl apply -f ./deployments/rails/secret.yaml
	kubectl apply -f ./deployments/rails/cm.yaml
	kubectl apply -f ./deployments/rails/jobs/db-create.yaml
deploy:
	kubectl apply -f ./deployments/rails/jobs/db-migrate.yaml
	kubectl apply -f ./deployments/rails/jobs/db-seed.yaml
	kubectl delete -f ./deployments/rails/jobs
	kubectl apply -f ./deployments/rails
