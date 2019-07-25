## Metrics

This will install both Prometheus and Grafana for metrics collection and visualization.

1. Get your Ambassador IP address and update the `AMBASSADOR_URL` variable in `env.sh` to `AMBASSADOR_URL=https://${AMBASSADOR_IP/`

2. Install the Prometheus Operator, Grafana, and configure the operator.

   ```
   make apply-monitoring
   ```

3. Send some traffic through Ambassador (metrics won't appear until some traffic is sent). You can just run the `curl` command to httpbin above a few times.

4. Access the grafana dashboard at https://${AMBASSADOR_IP/grafana/ and log in using username `admin`, password `admin`.

5. On the left panel, hover over the Dashboards icon (looks like a 2x2 matrix) and click `Manage`

6. Click on `Ambassador` to pull up the pre-configured Grafana dashboard.
