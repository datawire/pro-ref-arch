# Rate limiting

This module configures the Pro rate limiting service.

1. Deploy the `pythonnode` test service: `kubectl apply -f pythonnode.yaml`.

2. Observe the `Mapping`s in pythonnode.yaml. 

   You will see a `labels` applied to the latency `Mapping`. This configures Ambassador to label the request with the string `pythonnode`. We will configure Ambassador to `RateLimit` off this label.

   ```
      ---
      apiVersion: ambassador/v1
      kind: Mapping
      name: latency_mapping
      prefix: /latency/
      rewrite: ""
      method: GET
      service: pythonnode.default.svc.cluster.local
      labels:
        ambassador:
          - string_request_label:
            - pythonnode
   ```


3. Configure the `RateLimit`:

   ```
   kubectl apply -f ratelimit.yaml
   ```
   
   We have now configured Ambassador to limit requests containing the label `pythonnode` to 5 requests per minute. We use requests per minute for simplicity while testing, other time units (second, hour, day) are acceptable as well.

4. Test the `RateLimit`:

   ```
   ./ratelimit-test.sh
   ```

   This is a simple bash script that sends a `cURL` to http://$AMBASSADOR_IP/latency/ every second. You will notice that after the 5th request, Ambassador is returning a 429 instead of 200 to requests to the `/latency/` endpoint.
   
   Requests to `/healthcheck` are not rate limited. 