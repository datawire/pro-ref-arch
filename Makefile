# Set to non-empty to use kubernaut or teleproxy
USE_KUBERNAUT ?=
USE_TELEPROXY ?=

NAME = pro-ref-arch
include build-aux/kubeapply.mk
include build-aux/help.mk
ifneq ($(USE_KUBERNAUT),)
  include build-aux/kubernaut-ui.mk
endif
ifneq ($(USE_TELEPROXY),)
  include build-aux/teleproxy.mk
endif
.DEFAULT_GOAL = help
define help.body
# This Makefile will help you quickly apply a core set of tested
# configurations for Ambassador Pro that integrate monitoring,
# distributed tracing, and more.
endef

apply-%: $(KUBEAPPLY) $(KUBECONFIG) %/ env.sh
	set -a && . ./env.sh && $(KUBEAPPLY) -f $*
.PHONY: apply-%

apply-ambassador: ## Apply YAML for Ambassador Pro

# TODO: cloud-infrastructure

env.sh:
	$(error 'env.sh' does not exist.  Copy 'env.sh.example' to 'env.sh' and edit it to include your Pro license key)

apply-api-auth:
	set -a && . ./env.sh && $(KUBEAPPLY) -f api-auth-with-github

apply-consul-connect-integration: ## Apply YAML for integration between Consul and Ambassador Pro
apply-consul-connect-integration: apply-consul-connect env.sh
	set -a && . ./env.sh && $(KUBEAPPLY) -f consul-connect/ambassador-consul-connector.yaml
apply-consul-connect: ## Apply Helm chart to install Consul to the cluster
apply-consul-connect: apply-helm env.sh
	helm repo add consul https://consul-helm-charts.storage.googleapis.com
	[ -n "$$(helm ls --all consul)" ] || helm install --wait --name=consul consul/consul -f ./consul-connect/values.yaml
	set -a && . ./env.sh && $(KUBEAPPLY) -f consul-connect/qotm.yaml
apply-helm: ## Apply YAML to ensure that Helm has appropriate permissions
apply-helm: $(KUBECONFIG)
	$(KUBEAPPLY) -f init/helm-rbac.yaml
	helm init --wait --service-account=tiller

# TODO: grpc-web

apply-jwt: ## Apply YAML for JWT validation filter

apply-monitoring: ## Apply YAML for Prometheus and Grafana

apply-ratelimit: ## Apply YAML for rate limiting

apply-tracing: ## Apply YAML for Zipkin and distributed tracing

apply-upgrade-to-pro: 

clean:
	rm -f */*.o
