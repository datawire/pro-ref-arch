#!/bin/bash

AMBASSADOR_IP=$(kubectl get svc ambassador -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

AMBASSADOR_POD=$(kubectl get po --selector=service=ambassador -o jsonpath='{.items[0].metadata.name}')

if [ $1 == "basic" ]
  then
    while true
    do
      curl -i -k https://$AMBASSADOR_IP/qotm/limited/
      sleep 1
    done
elif [ $1 == "local-user" ]
  then
    while true
    do
      curl -i -k https://$AMBASSADOR_IP/httpbin/ip
      sleep .5
    done
elif [ $1 == "remote-user" ]
  then
    while true
    do
      kubectl exec -it $AMBASSADOR_POD -c ambassador -- curl -i -k https://ambassador/httpbin/ip
      sleep .5
    done
      
fi