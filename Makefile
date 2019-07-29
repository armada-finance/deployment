CMD=kubectl
MINIKUBE=minikube
KUBEAPPLY=$(CMD) apply
NAMESPACE=default

.PHONY: help
help:
	@echo "============= Armada Makefile Targets =============\n"
	@echo "namespace:       creates the required namespace to run Armada"
	@echo "switch:          switches to Armada current namespace"
	@echo "ingreess:        deploys an Ingress Controller"
	@echo "keycloak:        creates all resources to run keycloak"
	@echo "all-minikube:     performs all tasks required to setup and run Armada on a Minikube cluster"

.PHONY: namespace
namespace:
	@echo "============= Creating Armada Namespace ============="
	# $(KUBEAPPLY) -f namespaces/local.yaml

.PHONY: switch
switch:
	@echo "============= Switching to Armada Namespace ============="
	$(CMD) config set-context --current --namespace=$(NAMESPACE)

.PHONY: ingress
ingress:
	@echo "============= Deploying Ingress Controller ============="
	$(MINIKUBE) addons enable ingress
	# $(KUBEAPPLY) -f ingress-controller/armada-nginx-config.yaml -n $(NAMESPACE)
	# $(KUBEAPPLY) -f ingress-controller/armada-nginx-controller.yaml -n $(NAMESPACE)
	# $(KUBEAPPLY) -f ingress-controller/armada-nginx-nodeport.yaml -n $(NAMESPACE)

.PHONY: keycloak
keycloak:
	@echo "============= Creating Armada Keycloak ============="
	$(KUBEAPPLY) -f sso/keycloak-secret.yaml -n $(NAMESPACE)
	$(KUBEAPPLY) -f sso/keycloak-deployment.yaml -n $(NAMESPACE)
	$(KUBEAPPLY) -f sso/keycloak-service.yaml -n $(NAMESPACE)

.PHONY: all-minikube
all-minikube:
	@echo "============ Setup and Run Armada on Minikube ============="
	$(MAKE) namespace
	$(MAKE) switch
	$(MAKE) keycloak