# gRPC-Web and Ambassador

Since Ambassador is built on Envoy, it natively supports requests between gRPC-web clients and backends. This is a simple exaple to demonstrate the functionality.

Ambassador should already be configured to proxy gRPC-web requests. This is configured in the Ambassador `Module` in `ambassador/03-ambassador-service.yaml`:

```yaml
      ---
      apiVersion: ambassador/v1
      kind: Module
      name: ambassador
      config:
        enable_grpc_web: True
```


1. Create the gRPC-web service:

   ```
   kubectl apply -f grpc_web.yaml
   ```

2. Update the client with your $AMBASSADOR_IP

   Replace $AMBASSADOR_IP in line 7 of `./client/client.js` with the value of your $AMBASSADOR_IP

   ```js
   7. var echoService = new EchoServiceClient('https://$AMBASSADOR_IP', null, null);
   ```

3. Build the client

   ```
   make client.build
   ```

4. Open  `./client/client.html` in you web-browser

   **Note:** Since Ambassador is using a self-signed certificate you will need to add an exception to your browser to allow requests to `$AMBASSADOR_IP`.

5. This send a request to the backend gRPC echo service. You can see this is the logs from that service:

   ```
   $ kubectl get pods

   NAME                                    READY   STATUS    RESTARTS   AGE
   ...
   grpc-echo-54c78566cb-ds59w              1/1     Running   0          3h
   ...

   $ kubectl logs grpc-echo-54c78566cb-ds59w 

   2019/03/12 14:48:48 metadata received: 
   x-forwarded-proto : http
   x-envoy-expected-rq-timeout-ms : 3000
   x-grpc-web : 1
   user-agent : Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36
   accept-encoding : gzip, deflate
   accept-language : en-US,en;q=0.9
   origin : null
   requested-status : 7
   x-request-id : a264fd0c-f771-42f2-bf9a-ac1dc7fc6fad
   grpc-accept-encoding : identity,deflate,gzip
   x-user-agent : grpc-web-javascript/0.1
   x-forwarded-for : 65.217.185.138
   content-type : application/grpc
   x-envoy-external-address : 65.217.185.138
   x-envoy-original-path : /echo.EchoService/Echo
   :authority : 35.196.239.93
   accept : application/grpc-web-text

   2019/03/12 14:48:48 setting response: {
     "request": {
       "headers": {
         ":authority": "35.196.239.93",
         "accept": "application/grpc-web-text",
         "accept-encoding": "gzip, deflate",
         "accept-language": "en-US,en;q=0.9",
         "content-type": "application/grpc",
         "grpc-accept-encoding": "identity,deflate,gzip",
         "origin": "null",
         "requested-status": "7",
         "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36",
         "x-envoy-expected-rq-timeout-ms": "3000",
         "x-envoy-external-address": "65.217.185.138",
         "x-envoy-original-path": "/echo.EchoService/Echo",
         "x-forwarded-for": "65.217.185.138",
         "x-forwarded-proto": "http",
         "x-grpc-web": "1",
         "x-request-id": "a264fd0c-f771-42f2-bf9a-ac1dc7fc6fad",
         "x-user-agent": "grpc-web-javascript/0.1" 
       }
     },
     "response": {
       "headers": {
         ":authority": "35.196.239.93",
         "accept": "application/grpc-web-text",
         "accept-encoding": "gzip, deflate",
         "accept-language": "en-US,en;q=0.9",
         "content-type": "application/grpc",
         "grpc-accept-encoding": "identity,deflate,gzip",
         "origin": "null",
         "requested-status": "7",
         "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36",
         "x-envoy-expected-rq-timeout-ms": "3000",
         "x-envoy-external-address": "65.217.185.138",
         "x-envoy-original-path": "/echo.EchoService/Echo",
         "x-forwarded-for": "65.217.185.138",
         "x-forwarded-proto": "http",
         "x-grpc-web": "1",
         "x-request-id": "a264fd0c-f771-42f2-bf9a-ac1dc7fc6fad",
         "x-user-agent": "grpc-web-javascript/0.1"
       }
     } 
   }
   ```
