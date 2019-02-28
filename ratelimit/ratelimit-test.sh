#!/bin/bash

AMBASSADOR_IP=$(kubectl get svc ambassador -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
while true
do
    curl -i http://$AMBASSADOR_IP/latency/
    sleep 1
done