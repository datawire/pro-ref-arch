# Ambassador Pro Reference Architecture

This repository contains a core set of tested configurations for Ambassador Pro that integrates monitoring, distributed tracing, and more.

## Initial setup

1. If you're on GKE, make sure you have an admin cluster role binding:

```
kubectl create clusterrolebinding my-cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud info --format="value(config.account)")
```

2. Clone this repository locally:

```
git clone https://github.com/datawire/pro-ref-arch.git
```

3. Add your license key to the `ambassador/ambassador-pro.yaml` file.

4. Initialize Helm with the appropriate permissions.

```
kubectl apply -f init/helm-rbac.yaml
helm init --service-account=tiller
```

## Installing the reference architecture

This repository is broken into individual modules. The modules should be installed in the following order.

1. Service mesh. Currently the only service mesh module available is the `consul-connect` module. Follow the instructions in the `consul-connect/README.md` to set up Consul Connect.

2. Ambassador. Instructions on installing Ambassador are below.

3. Add-on modules. These can be installed in any order. The current list of add-on modules are. The specific instructions for each add-on module is in the README file in each of the add-on directories.
  
   * `monitoring` which configures Prometheus and Grafana
   * `tracing` which configures Zipkin and distributed tracing
   * `ratelimit` which configures rate limiting
   * COMING SOON: `keycloak` integration with Keycloak IDP for authentication
   * COMING SOON: `jwt` JWT validation
   * COMING SOON: `apikey` API key configuration
   * COMING SOON: `istio` Istio configuration

## Ambassador Pro basic installation

1. Install Ambassador with the following commands along with a basic route to the `httpbin` service.
   
   ```
   kubectl apply -f statsd-sink.yaml
   kubectl apply -f ambassador-pro.yaml
   kubectl apply -f ambassador-service.yaml
   kubectl apply -f httpbin.yaml
   ```

2. Get the IP address of Ambassador: `kubectl get svc ambassador`.

3. Send a request to `httpbin`; this request will succeed since this request is sent to a service outside of the service mesh.

   ```
   curl -v http://{AMBASSADOR_IP}/httpbin/ip
   {
      "origin": "108.20.119.124, 35.184.242.212, 108.20.119.124"
   }
   ```

### Service Mesh integration

If you have previously installed Consul Connect, the following steps will deploy the Consul Connect integration which will automatically encrypt TLS connections between Ambassador and the mesh.

1. Install the QOTM demo service:

   ```
   kubectl apply -f consul-connect/qotm.yaml
   ```

2. Send a request to the QOTM service; this request will fail because the request is not properly encrypted.


   ```shell
   curl -v http://{AMBASSADOR_IP}/qotm/

   < HTTP/1.1 503 Service Unavailable
   < content-length: 57
   < content-type: text/plain
   < date: Thu, 21 Feb 2019 16:29:30 GMT
   < server: envoy
   < 
   upstream connect error or disconnect/reset before headers
   ```

3. Now install the Consul Connect integration.

   ```shell
   kubectl apply -f consul-connect/ambassador-consul-connector.yaml
   ```

4. Verify that the `ambassador-consul-connect` secret is created. This secret is created by the integration.

   ```shell
   kubectl get secrets

   ambassador-consul-connect                                 kubernetes.io/tls                     2     
   ambassador-pro-consul-connect-token-j67gs                 kubernetes.io/service-account-token   3     
   ambassador-pro-registry-credentials                       kubernetes.io/dockerconfigjson        1     
   ambassador-token-xsv9r                                    kubernetes.io/service-account-token   3     
   cert-manager-token-tggkd                                  kubernetes.io/service-account-token   3     
   consul-connect-injector-webhook-svc-account-token-4xpw9   kubernetes.io/service-account-token   3     
   ```

5. You can now send a request to QOTM, which will be encrypted with TLS. Note that we're sending an unencrypted HTTP request, which gets translated to TLS when the request is sent to Consul Connect.

   ```shell
   curl -v http://{AMBASSADOR_IP}/qotm/

   < HTTP/1.1 200 OK
   < content-type: application/json
   < content-length: 164
   < server: envoy
   < date: Thu, 21 Feb 2019 16:30:15 GMT
   < x-envoy-upstream-service-time: 129
   < 
   {"hostname":"qotm-794f5c7665-26bf9","ok":true,"quote":"The last sentence you read is often sensible nonsense.","time":"2019-02-21T16:30:15.572494","version":"1.3"}
   ```

