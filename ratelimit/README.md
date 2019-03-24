# Rate Limiting

Ambassador Pro includes a dynamic rate limiting service that can handle a wide variety of rate limiting use cases. 

## Global Rate Limiting

Suppose we want to limit a certain subset of users to only 10 requests per minute for any requests through Ambassador. We can configure a global rate limit that can rate limit based off a header that identifies this subset of users. Users with the header `x-limited-user: true` will be limited to 10 requests per minute. 

1. Observe the ambassador `Module` in `ambassador/03-ambassador-service.yaml` we deployed earlier.

   You will see a `default_label` set in the config. This configures Ambassador to label every request through Ambassador with a check for `x-limited-user` so the rate limiting service can check it. 

   ```yaml
         ---
         apiVersion: ambassador/v1
         kind: Module
         name: ambassador
         config:
           enable_grpc_web: True
             default_label_domain: ambassador
             default_labels:
               ambassador:
                 defaults:
                 - x_limited_user:
                     header: "x-limited-user"
                     omit_if_not_present: true
   ```

2. Configure the global rate limit

   ```
   kubectl apply -f rl-global.yaml
   ```

   This configures Ambassador's rate limiting service to look for the `x_limited_user` label and, if set to `true`, limit the requests to 10 per minute.

3. Test the rate limit

   We provide a simple way to test that this global rate limit is working. Run the simple shell script `ratelimit-test.sh` in "global" mode to send requests to the `qotm` and `httpbin` endpoints. You will see, after a couple of request, that requests that set `x-limited-user: true` will be returned a 429 by Ambassador after 10 requests but requests with `x-limited-user: false` are allowed.


   ```
   ./ratelimit-test.sh global
   ```

## Per User Rate Limiting

Suppose we notice a couple of unlimited users are abusing their limitless permissions and overwhelming the `httpbin` endpoint. To ensure fairness in allocating resources to all of our users, we can enable rate limiting based off the incoming client IP address. We do this with the `remote_address` field that Envoy configures on each request. 

1. Configure the label in the `Mapping`

   Observe the `Mapping` in `ambassador/04-httpbin.yaml` we deployed earlier. You will see a `label` applied that labels requests to `/httpbin/` with the requests `remote_address`. Ambassador Pro's rate limiting service will use this label to identify the client IP of the request.

   ```yaml
         ---
         apiVersion: ambassador/v1
         kind:  Mapping
         name:  httpbin_mapping
         prefix: /httpbin/
         service: httpbin.org:80
         host_rewrite: httpbin.org
         labels:
           ambassador:
             - request_label_group:
               - remote_address
   ```

2. Configure the `RateLimit`

   ```
   kubectl apply -f rl-per-user.yaml
   ```

   This will tell Ambassador Pro's rate limiting service to limit the number of requests from each user to 20 requests per minute. This will stop our greedy users from issuing too many requests while not impacting the performance of our more considerate users.

3. Test The rate limit

   We provide a simple way to test that this rate limit is working. By running the `ratelimit-test.sh` script in "local-user" mode you will see that your local machine is issuing a lot of request to the system and Ambassador is responding with a 429 after 20 requests. 

   ```
   ./ratelimit-test.sh local-user
   ```

   Now, from another terminal, run the `ratelimit-test.sh` script in "remote-user" mode to verify that only your local machine is being rate limited. This will issue a `kubectl exec` command to issue curl requests from Ambassador running inside your cluster. You will see these requests are allowed through even though your local machine is locked out.

   ```
   ./ratelimit-test.sh remote-user
   ```

## Basic Request Rate Limiting

Suppose one of our endpoints is not very resilient to much load at all and we want to limit the amount of requests to it regardless of if the request has `x-limited-user: true` or not.

The QoTM service deployed from the Ambassador directory exposes the routes `/qotm/limited/` and `/qotm/open/`. The `/qotm/limited/` can only handle as much load as is defined by the `REQUEST_LIMIT` environment variable (defaults to 5), meaning that after 5 requests in a minute, the server will return a 500 error. The `/qotm/open/` endpoint, however, can handle higher loads. 

You can test this by running the `ratelimit.sh` script in "basic" mode which sends a request every second. After the fifth request you will see the server a 500 error.

To protect our QoTM app, we need to put a rate limit on the number of requests that are allowed to the `/qotm/limited/` route. 

This module configures the Pro rate limiting service.

1. Observe the `Mapping`s in `ambassador/05-qotm.yaml` we deployed earlier.

   You will see a `labels` applied to the `qotm_limited_mapping`. This configures Ambassador to label the request with the string `qotm`. We will configure Ambassador to `RateLimit` off this label.

   ```yaml
      ---
      apiVersion: ambassador/v1
      kind: Mapping
      name: qotm_limited_mapping
      prefix: /qotm/limited/
      rewrite: /limited/
      service: qotm
      labels:
        ambassador:
          - string_request_label:
            - qotm
   ```

   **Note:** There is no label applied to the `qotm_open_mapping`.


2. Configure the `RateLimit`:

   ```
   kubectl apply -f rl-basic.yaml
   ```
   
   We have now configured Ambassador to limit requests containing the label `qotm` to 5 requests per minute.

3. Test the `RateLimit`:

   ```
   ./ratelimit-test.sh basic
   ```

   This is a simple bash script that sends a `cURL` to http://$AMBASSADOR_IP/qotm/limited/ every second. You will notice that after the 5th request, Ambassador is returning a 429 instead of 200 to requests to the `/qotm/limited/` endpoint.
   
   The `/qotm/open/` endpoint does not have the same load restrictions and therefore does not need to be rate limited. 
