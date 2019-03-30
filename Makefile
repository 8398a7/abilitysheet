PUMA_POD = $(shell kubectl get po -n abilitysheet -l app.kubernetes.io/component=puma -o name | cut -c5-)

deploy-dashboard:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
	$(shell open http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/)
	kubectl proxy
helm-deploy:
	helm init --wait
	$(MAKE) helm-upgrade
	$(shell open https://localhost)
helm-preview:
	helm install --dry-run --debug ./deployments/abilitysheet -n preview --namespace abilitysheet
helm-upgrade:
	helm upgrade prod ./deployments/abilitysheet --install --wait --namespace abilitysheet
helm-delete:
	helm del --purge prod
pod-exec:
	kubectl exec -it $(PUMA_POD) -n abilitysheet /bin/sh
