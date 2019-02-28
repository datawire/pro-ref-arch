## Metrics

This will install both Prometheus and Grafana for metrics collection and visualization.

1. Install the Prometheus Operator.

   ```
   kubectl apply -f monitoring/prometheus.yaml
   ```

2. Wait 30 seconds until the `prometheus-operator` pod is in the `Running` state.

3. Create the rest of the monitoring setup:

   ```
   kubectl apply -f monitoring/prom-cluster.yaml
   kubectl apply -f monitoring/prom-svc.yaml
   kubectl apply -f monitoring/servicemonitor.yaml
   kubectl apply -f monitoring/grafana.yaml
   ```

4. Send some traffic through Ambassador (metrics won't appear until some traffic is sent). You can just run the `curl` command to httpbin above a few times.

5. Get the IP address of Grafana: `kubectl get svc grafana`

6. In your browser, go to the `$GRAFANA_IP` and log in using username `admin`, password `admin`.

7. Configure Prometheus as the Grafana data source. Give it a name, choose type Prometheus, and point the HTTP URL to `http://prometheus.default:9090`. Save & Test the Data Source.

8. Import a dashboard. Click on the + button, and then choose Import. Upload the `ambassador-dashboard.json` file to Grafana. Choose the data source you created in the previous step, and click import.

9. Go to the Ambassador dashboard!