PUMA_POD = $(shell kubectl get po -n abilitysheet -l app.kubernetes.io/component=puma -o name | cut -c5-)

open-dashboard:
	$(shell open https://dashboard-127-0-0-1.nip.io)
open-app:
	$(shell open https://app-127-0-0-1.nip.io)
helm-deploy:
	helm init --wait
	$(MAKE) helm-upgrade open-dashboard open-app
helm-preview:
	helm install --dry-run --debug ./deployments/abilitysheet -n preview --namespace abilitysheet
helm-upgrade:
	helm upgrade prod ./deployments/abilitysheet --install --wait --namespace abilitysheet
helm-delete:
	helm del --purge prod
pod-exec:
	kubectl exec -it $(PUMA_POD) -n abilitysheet /bin/sh
