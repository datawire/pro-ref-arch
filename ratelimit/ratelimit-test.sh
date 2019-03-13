#!/bin/bash

AMBASSADOR_IP=$(kubectl get svc ambassador -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
while true
do
    curl -i -k https://$AMBASSADOR_IP/qotm/limited/
    sleep 1
done