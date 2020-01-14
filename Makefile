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

apply-%: $(KUBEAPPLY) $(KUBECONFIG) %/
	set -a && . ./env.sh && $(KUBEAPPLY) -f $* --timeout=5m
.PHONY: apply-% create-license-key-secret

create-license-key-secret:
	-set -a && . ./env.sh &&\
	kubectl create secret generic ambassador-pro-license-key --from-literal=key=$${AMBASSADOR_LICENSE_KEY}\
	||\
	kubectl delete secret ambassador-pro-license-key &&\
	kubectl create secret generic ambassador-pro-license-key --from-literal=key=$${AMBASSADOR_LICENSE_KEY}

## Apply YAML for Ambassador Pro
apply-ambassador: create-license-key-secret\
	apply-%

# TODO: cloud-infrastructure

env.sh:
	$(error 'env.sh' does not exist.  Copy 'env.sh.example' to 'env.sh' and edit it to include your Pro license key and configure devportal )

apply-api-auth:
	set -a && . ./env.sh && $(KUBEAPPLY) -f api-auth-with-github

apply-consul-connect-integration: ## Apply YAML for integration between Consul and Ambassador Pro
apply-consul-connect-integration: apply-consul-connect apply-consul-connector env.sh

apply-consul-connector: ## Just apply the consul connector
apply-consul-connector: 
	set -a && . ./env.sh && $(KUBEAPPLY) -f consul-connect/ambassador-consul-connector.yaml
apply-consul-connect: ## Apply Helm chart to install Consul to the cluster
apply-consul-connect: env.sh
	-git clone --single-branch --branch v0.8.1 https://github.com/hashicorp/consul-helm.git
	[ -n "$$(helm ls --all --all-namespaces | grep consul)" ] || helm install consul ./consul-helm -f ./consul-connect/values.yaml --wait
	set -a && . ./env.sh && $(KUBEAPPLY) -f consul-connect/qotm.yaml

# TODO: grpc-web

apply-jwt: ## Apply YAML for JWT validation filter

apply-monitoring: ## Apply YAML for Prometheus and Grafana

apply-ratelimit: ## Apply YAML for rate limiting

apply-tracing: ## Apply YAML for Zipkin and distributed tracing

apply-upgrade-to-pro: 

clean:
	rm -f */*.o
	rm -rf consul-helm

.env.sh.ok: env.sh env.sh.example Makefile
	@env -i PIPESTATUS=1 sh -c "set" | cut -d= -f1 > .env.sh.empty
	@env -i sh -c ". env.sh.example; set" | cut -d= -f1 | join -v2 .env.sh.empty - > .env.sh.example
	@env -i sh -c ". env.sh; set" | cut -d= -f1 | join -v2 .env.sh.empty - > .env.sh
	@join -v2 .env.sh .env.sh.example | sed -e's/^/	- /' > .env.sh.missing
	@if test "$$(cat .env.sh.missing)" != ""; then \
		echo "Please consult env.sh.example and upgrade your env.sh as it's missing some settings:"; \
		cat .env.sh.missing; \
		false; \
	fi
	@. env.sh; if [ "$${AMBASSADOR_URL}" == "$${AMBASSADOR_URL#[hH][tT][tT][pP][sS]://}" ]; then \
	  echo "$$(grep -n AMBASSADOR_URL env.sh /dev/null|cut -d: -f-2):error:  AMBASSADOR_URL has to be an absolute https URL."; \
	  false; \
	fi
	@touch .env.sh.ok
