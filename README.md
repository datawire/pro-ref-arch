# Ambassador Pro Reference Architecture

This repository contains a core set of tested configurations for Ambassador Pro that integrates monitoring, distributed tracing, and more. 

## Quick start

If you're new to Ambassador Pro, check out https://www.getambassador.io/user-guide/ambassador-pro-install for a quick start.


## Installing the reference architecture

This repository is broken into individual modules. The modules should be installed in the following order.

1. Service mesh. Currently the only service mesh module available is the `consul-connect` module. Follow the instructions in the `consul-connect/README.md` to set up Consul Connect.

2. Ambassador. Instructions on deploying Ambassador are covered in the Quickstart.

3. Add-on modules. These can be installed in any order. The current list of add-on modules are. The specific instructions for each add-on module is in the README file in each of the add-on directories.
  
   * `monitoring` which configures Prometheus and Grafana
   * `tracing` which configures Zipkin and distributed tracing
   * `ratelimit` which configures rate limiting
   * `jwt` JWT validation filter
   * COMING SOON: `keycloak` integration with Keycloak IDP for authentication
   * COMING SOON: `apikey` API key configuration
   * COMING SOON: `istio` Istio configuration
