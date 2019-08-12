CMD=kubectl
MINIKUBE=minikube
KUBEAPPLY=$(CMD) apply
NAMESPACE=default

.PHONY: help
help:
	@echo "============= Armada Makefile Targets =============\n"
	@echo "ingress-minikube:    deploys an Ingress Controller into Minikube Cluster"
	@echo "keycloak:            creates all resources to run keycloak"
	@echo "all-minikube:        performs all tasks required to setup and run Armada on a Minikube cluster"

.PHONY: ingress-minikube
ingress-minikube:
	@echo "============= Deploying Ingress Controller into Minikube ============="
	$(MINIKUBE) addons enable ingress

.PHONY: keycloak
keycloak:
	@echo "============= Creating Armada Keycloak ============="
	$(KUBEAPPLY) -f sso/keycloak-secret.yaml -n $(NAMESPACE)
	$(KUBEAPPLY) -f sso/keycloak-deployment.yaml -n $(NAMESPACE)
	$(KUBEAPPLY) -f sso/keycloak-service.yaml -n $(NAMESPACE)
	$(KUBEAPPLY) -f sso/keycloak-ingress.yaml -n $(NAMESPACE)

	@echo "Keycloak address:"
	$(MINIKUBE) service keycloak --url

.PHONY: all-minikube
all-minikube:
	@echo "============ Setup and Run Armada on Minikube ============="
	$(MAKE) ingress-minikube
	$(MAKE) keycloak