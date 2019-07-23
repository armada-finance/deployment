CMD=kubectl
KUBEAPPLY=$(CMD) apply
NAMESPACE=armada-local

.PHONY: help
help:
	@echo "============= Armada Makefile Targets =============\n"
	@echo "namespace:       creates the required namespace to run Armada"
	@echo "switch:          switches to Armada current namespace"
	@echo "keycloak:        creates all resources to run keycloak"
	@echo "all:             performs all tasks required to setup and run Armada cluster"

.PHONY: namespace
namespace:
	@echo "============= Creating Armada Namespace ============="
	$(KUBEAPPLY) -f namespaces/local.yaml

.PHONY: switch
switch:
	@echo "============= Switching to Armada Namespace ============="
	$(CMD) config set-context --current --namespace=$(NAMESPACE)

.PHONY: keycloak
keycloak:
	@echo "============= Creating Armada Keycloak ============="
	$(KUBEAPPLY) -f sso/keycloak-secret.yaml -n $(NAMESPACE)
	$(KUBEAPPLY) -f sso/keycloak-deployment.yaml -n $(NAMESPACE)
	$(KUBEAPPLY) -f sso/keycloak-service.yaml -n $(NAMESPACE)

.PHONY: all
all:
	@echo "============ Setup and Run Armada ============="
	$(MAKE) namespace
	$(MAKE) switch
	$(MAKE) keycloak