# Ambassador Reference Architecture

This repository contains a set of tested configurations sets for quickly deploying and testing features of the Ambassador Edge Stack.


## Quick start

If you're new to Ambassador, check out https://www.getambassador.io/user-guide/getting-started for a quick start.

## Upgrading from Ambassador OSS

If you're already using Ambassador, you'll want to follow the instructions for upgrading here: https://www.getambassador.io/early-access/user-guide/upgrade-to-edge-stack/.

## Installing the reference architecture

This repository is broken into individual modules. 
A `Makefile` is provided that will deploy the modules into a Kubernetes cluster.

### Prequesites
- A Kubernetes cluster version 1.11 or later
- The [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) command-line interface.
- [GNU Make](https://www.gnu.org/software/make/)

The following modules are available to be installed. Follow the README in each directory for installation instructions.

* Consul Connect integration (`make apply-consul-connect-integration`): Deploy [Consul](https://www.consul.io) and the Ambassador Consul integration.
* Keycloak / GitHub SSO (`make apply-api-auth`): Deploy keycloak and configure Ambassador to require SSO.
* JWT (`make apply-jwt`): Configure Ambassador to validate a JWT on an example endpoint.
* Monitoring (`make apply-monitoring`): Set up Prometheus and Grafana
* Rate limiting (`make apply-ratelimit`): Configure Ambassador with some simple rate limiting examples.

**NOTE:** Some Modules make some basic assumptions about your Ambassador and cluster environment
* You are running in a cloud environmen that can provision load balancers
* You have Ambassador Edge Stack installed and TLS termination configured
* You are a cluster admin
* YAML configurations are able to be applied against your cluster

Still to come:

   * Tracing service example
   * [Istio](https://istio.io) configuration

