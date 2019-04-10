## Distributed Tracing

**Note:** The Ambassador Pro installed by this reference architecture is secured with a self-signed certificate. You will need to create a browser exception, install your own certificate, or remove the tls `Module` from the `03-ambassador-service.yaml` file to follow the example.

This will set up Zipkin for distributed tracing, along with a sample microservice application ("microdonuts").

1. Create the `TracingService`

    ```
    kubectl apply -f tracing/zipkin.yaml
    kubectl apply -f tracing/tracing-config.yaml
    ```
  
    This will tell Ambassador to generate a tracing header for all requests through it. Ambassador needs to be restarted for this configuration to take effect.

2. Restart Ambassador to reload the Tracing configuration.

    - Get your Ambassador Pod name

       ```
       kubectl get pods

       ambassador-7bbd676d59-7b8w6                                   2/2     Running   0          10m
       ambassador-pro-consul-connect-integration-6d7d489b4b-fwndt    1/1     Running   0          4h
       ambassador-pro-redis-6cbb7dfbb-pzg66                          1/1     Running   0          4h
       consul-76ks4                                                  1/1     Running   0          4h
       consul-connect-injector-webhook-deployment-7846847f9f-r8w8p   1/1     Running   0          4h
       consul-p89q4                                                  1/1     Running   0          4h
       consul-server-0                                               1/1     Running   0          4h
       consul-server-1                                               1/1     Running   0          4h
       consul-server-2                                               1/1     Running   0          4h
       consul-vvl7b                                                  1/1     Running   0          4h
       qotm-794f5c7665-26bf9                                         2/2     Running   0          4h
       zipkin-98f9cbc58-zjksk                                        1/1     Running   0          7m
       ````

    - Deleting the pod will tell Kubernetes to restart another one

       ```
       kubectl delete po ambassador-7bbd676d59-7b8w6 
       pod "ambassador-7bbd676d59-7b8w6" deleted
       ```

    - Wait for the new Pod to come online

3. Apply the micro donuts demo service

    ```
    kubectl apply -f tracing/microdonut.yaml
    ```

4. Test the tracing service

    - From a web-browser, go to https://{AMBASSADOR_IP}/microdonut/
    - Use the UI to select and order a number of donuts
    - After clicking `order`, from a new tab, access https://{AMBASSADOR_IP}/zipkin/
    - In the search parameter box, expand the `Limit` to 1000 so you can see all of the traces
    - Click `Find Traces` and you will see a list of Traces for requests through Ambassador.
    - Find a trace that has > 2 spans and you will see a trace for all the request our donut order made
    