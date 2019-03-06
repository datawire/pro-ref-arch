# Rate limiting

This module configures the Pro rate limiting service.

1. Observe the `Mapping`s in `ambassador/05-qotm.yaml` we deployed earlier.

   You will see a `labels` applied to the `qotm_mapping`. This configures Ambassador to label the request with the string `qotm`. We will configure Ambassador to `RateLimit` off this label.

   ```
      ---
      apiVersion: ambassador/v1
      kind: Mapping
      name: qotm_mapping
      prefix: /qotm/
      service: qotm
      labels:
        ambassador:
          - string_request_label:
            - qotm
   ```

   **Note:** There is no label applied to the `quote_mapping`.


2. Configure the `RateLimit`:

   ```
   kubectl apply -f ambassador-pro-ratelimit.yaml
   kubectl apply -f ratelimit.yaml
   ```
   
   We have now configured Ambassador to limit requests containing the label `qotm` to 5 requests per minute. We use requests per minute for simplicity while testing, other time units (second, hour, day) are acceptable as well.

3. Test the `RateLimit`:

   ```
   ./ratelimit-test.sh
   ```

   This is a simple bash script that sends a `cURL` to http://$AMBASSADOR_IP/qotm/ every second. You will notice that after the 5th request, Ambassador is returning a 429 instead of 200 to requests to the `/qotm/` endpoint.
   
   Requests to `/quote/` are not rate limited. 