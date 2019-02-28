# Ambassador Consul Connect Integration

## Consul Connect Setup

We will install Consul via Helm.

**Note:** The `values.yaml` file is used to configure the Helm installation. See [documentation](https://www.consul.io/docs/platform/k8s/helm.html#configuration-values-) on different options. We're providing a sample `values.yaml` file.

```shell
helm repo add consul https://consul-helm-charts.storage.googleapis.com
helm install --name=consul consul/consul -f ./consul-connect/values.yaml
```

This will install Consul with Connect enabled. 

**Note:** Sidecar auto-injection is not configured by default and can enabled by setting `connectInject.default: true` in the `values.yaml` file.

## Verify the Consul installation

Verify you Consul installation by accessing the Consul UI. 

```shell
kubectl port-forward service/consul-ui 8500:80
```

Go to http://localhost:8500 from a web-browser.

If the UI loads correctly and you see the consul service, it is safe to assume Consul is installed correctly.

## Install the demo QoTM service

Next we will deploy the QoTM service. We will do this before deploying the consul connect integration to show how Ambassador requires the secret created by that service to successfully route to the QoTM pod with the connect sidecar

```shell
kubectl apply -f qotm.yaml
```

Then send a curl to the service to verify it does not work.

```shell
curl -v http://{AMBASSADOR_IP}/qotm/

< HTTP/1.1 503 Service Unavailable
< content-length: 57
< content-type: text/plain
< date: Thu, 21 Feb 2019 16:29:30 GMT
< server: envoy
< 
upstream connect error or disconnect/reset before headers[nkrause@MacBook-Pro consul-connect
```

## Install the Consul Connect Integration

Finally we will install the connect integration so Ambassador can route to the connect-powered QoTM service.

```shell
kubectl apply -f ambassador-consul-connector.yaml
```

#### Verify the pod started correctly

```shell
kubectl get pods 

NAME                                                          READY   STATUS    RESTARTS   AGE
ambassador-77767b7667-hc7q4                                   2/2     Running   3          18m
ambassador-pro-consul-connect-integration-6d7d489b4b-fwndt    1/1     Running   0          12m
ambassador-pro-redis-6cbb7dfbb-pzg66                          1/1     Running   0          18m
consul-76ks4                                                  1/1     Running   0          26m
consul-connect-injector-webhook-deployment-7846847f9f-r8w8p   1/1     Running   0          26m
consul-p89q4                                                  1/1     Running   0          26m
consul-server-0                                               1/1     Running   0          26m
consul-server-1                                               1/1     Running   0          26m
consul-server-2                                               1/1     Running   0          26m
consul-vvl7b                                                  1/1     Running   0          25m
qotm-794f5c7665-26bf9                                         2/2     Running   0          20m
```

#### Verify the secret `ambassador-consul-connect` was created 

```shell
kubectl get secrets

ambassador-consul-connect                                 kubernetes.io/tls                     2     
ambassador-pro-consul-connect-token-j67gs                 kubernetes.io/service-account-token   3     
ambassador-pro-registry-credentials                       kubernetes.io/dockerconfigjson        1     
ambassador-token-xsv9r                                    kubernetes.io/service-account-token   3     
cert-manager-token-tggkd                                  kubernetes.io/service-account-token   3     
consul-connect-injector-webhook-svc-account-token-4xpw9   kubernetes.io/service-account-token   3     
```

#### Send a request to QoTM

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