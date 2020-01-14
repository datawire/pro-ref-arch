# Ambassador Consul Connect Integration

Ambassador integrates with Consul for service discovery and end-to-end TLS in your data center. This guide will quickly get Consul and a demo QoTM application installed with the Connect sidecar proxy enabled for mTLS between Ambassador and the QoTM service.

## Prerequesites

- [Helm 3](https://helm.sh/docs/)

   If you are using Helm 2, you can manually deploy consul following [Consul's documentation](https://www.consul.io/docs/platform/k8s/run.html#prerequisites)

## 1. Deploy Ambassador if you have not yet.

https://www.getambassador.io/user-guide/install

## 2. Deploy Consul, the Connect integration, and the QoTM demo application

```
make apply-consul-connect-integration
```

- Deploys Consul with Connect enabled using Consul's Helm chart. You can view the `values.yaml` file in this directory to see how Consul is configured.
- Deploys the QoTM application with the Connect sidecar proxy injected to enable mTLS between itself and Ambassador.
- Deploys the `ambassador-consul-connect-integration` to expose Consul Connect's TLS certificates to Ambassador.
- Registers a `Mapping` in Ambassador which will use Consul service discovery to route to the endpoint of the `qotm-proxy` service. 

If you already have Consul deployed, just deploy the Consul connector by running:

```
make apply-consul-connector
```

## 3. Send a request to the QoTM application via the Connect sidecar proxy

```
curl -k https://$AMBASSADOR_IP/qotm-consul/

{"hostname":"qotm-consul-79dc57bf8-mzvln","ok":true,"quote":"The light at the end of the tunnel is interdependent on the relatedness of motivation, subcultures, and management.","time":"2019-04-23T17:10:47.970806","version":"1.7"}
```

This request is sent through Ambassador directly to the Connect sidecar running in the `qotm-consul` pod. Ambassador encrypts this request using the TLS certificates exposed through the `ambassador-consul-connect-integration`. 

For more information on how Ambassador uses Consul service discovery to route to Consul endpoints:

[Consul Service Discovery](https://www.getambassador.io/user-guide/consul)
[End-to-end TLS with Consul](https://www.getambassador.io/reference/core/tls/#consul-mtls)
