# Ambassador Pro Reference Architecture

This repository contains a core set of tested configurations for Ambassador Pro that integrates monitoring, distributed tracing, and more. 

## Quick start

If you're new to Ambassador Pro, check out https://www.getambassador.io/user-guide/ambassador-pro-install for a quick start.

## Upgrading from Ambassador OSS

If you're already using Ambassador, you'll want to follow the instructions for upgrading here: https://www.getambassador.io/user-guide/upgrade-to-pro.

## Installing the reference architecture

This repository is broken into individual modules. A standard `Makefile` is provided that will deploy the modules into a Kubernetes cluster. The following modules are available:


* Ambassador (`make apply-ambassador`)
* Consul Connect (`make apply-consul-connect`)
* Consul Connect integration (`make apply-consul-connect-integration`)
* JWT (`make apply-jwt`)
* Monitoring (`make apply-monitoring`): Set up Prometheus and Grafana
* Rate limiting (`make apply-ratelimit`)
* Tracing (`make apply-tracing`): Zipkin and tracing example

Still to come:

   * `keycloak` integration with Keycloak IDP for authentication
   * `apikey` API key configuration
   * `istio` Istio configuration
