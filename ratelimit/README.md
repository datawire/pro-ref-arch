# Rate Limiting

Ambassador Pro includes a dynamic rate limiting service that can handle a wide variety of rate limiting use cases. 

## Prerequesites

1. [Install Ambassador Edge Stack](https://www.getambassador.io/user-guide/getting-started/)

2. Install the qotm service to test basic rate limiting

```
kubectl apply -f ratelimit/qotm.yaml
```

2. Update the quote backend to apply rate limit labels

```
kubectl apply -f ratelimit/quote-backend-mapping.yaml
```

## Per User Rate Limiting

Suppose we notice a couple of users are overwhelming the `quote-backend` endpoint. To ensure fairness in allocating resources to all of our users, we can enable rate limiting based off the incoming client IP address. We do this with the `remote_address` field that Envoy configures on each request. 

1. Configure the label in the `Mapping`

   Observe the `Mapping` in `ratelimit/quote-backend-mapping.yaml` we just deployed. You will see a `labels` applied that labels requests to `/backend/` with the requests `remote_address`. Ambassador Pro's rate limiting service will use this label to identify the client IP of the request.

   ```yaml
    ---
    apiVersion: getambassador.io/v2
    kind: Mapping
    metadata:
      name: quote-backend
      namespace: ambassador
    spec:
      prefix: /backend/
      service: quote
      labels:
        ambassador:
          - remote_address_label_group:
            - remote_address
   ```

2. Configure the `RateLimit`

   ```
   kubectl apply -f ratelimit/rl-per-user.yaml
   ```

   This will tell Ambassador Pro's rate limiting service to limit the number of requests from each user to 20 requests per minute. This will stop our greedy users from issuing too many requests while not impacting the performance of our more considerate users.

3. Test The rate limit

   We provide a simple way to test that this rate limit is working. By running the `ratelimit-test.sh` script in "local-user" mode you will see that your local machine is issuing a lot of request to the system and Ambassador is responding with a 429 after 20 requests. 

   ```
   cd ratelimit
   ./ratelimit-test.sh local-user
   ```

   Now, from another terminal, run the `ratelimit-test.sh` script in "remote-user" mode to verify that only your local machine is being rate limited. This will issue a `kubectl exec` command to issue curl requests from Ambassador running inside your cluster. You will see these requests are allowed through even though your local machine is locked out.

   ```
   cd ratelimit
   ./ratelimit-test.sh remote-user
   ```

## Basic Request Rate Limiting

Suppose one of our endpoints is not very resilient to much load at all.

The QoTM service we just deployed exposes the routes `/qotm/limited/` and `/qotm/open/`. The `/qotm/limited/` can only handle as much load as is defined by the `REQUEST_LIMIT` environment variable (defaults to 5), meaning that after 5 requests in a minute, the server will return a 500 error. The `/qotm/open/` endpoint, however, can handle higher loads. 

You can test this by running the `ratelimit.sh` script in "basic" mode which sends a request every second. After the fifth request you will see the server a 500 error.

To protect our QoTM app, we need to put a rate limit on the number of requests that are allowed to the `/qotm/limited/` route. 

This module configures the Pro rate limiting service.

1. Observe the `Mapping`s in `ambassador/05-qotm.yaml` we deployed earlier.

   You will see a `labels` applied to the `qotm_limited_mapping`. This configures Ambassador to label the request with the string `qotm`. We will configure Ambassador to `RateLimit` off this label.

   ```yaml
    ---
    apiVersion: getambassador.io/v2
    kind: Mapping
    metadata:
      name: qotm-limited
    spec:
      prefix: /qotm/limited/
      rewrite: /limited/
      service: qotm
      labels:
        ambassador:
          - request_label:
            - qotm
   ```

   **Note:** There is no label applied to the `qotm_open_mapping`.


2. Configure the `RateLimit`:

   ```
   kubectl apply -f ratelimit/rl-basic.yaml
   ```
   
   We have now configured Ambassador to limit requests containing the label `qotm` to 5 requests per minute.

3. Test the `RateLimit`:

   ```
   cd ratelimit
   ./ratelimit-test.sh basic
   ```

   This is a simple bash script that sends a `cURL` to http://$AMBASSADOR_IP/qotm/limited/ every second. You will notice that after the 5th request, Ambassador is returning a 429 instead of 200 to requests to the `/qotm/limited/` endpoint.
   
   The `/qotm/open/` endpoint does not have the same load restrictions and therefore does not need to be rate limited. 
