#!/bin/bash

AMBASSADOR_IP=$(kubectl get svc ambassador -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

AMBASSADOR_POD=$(kubectl get po --selector=service=ambassador -o jsonpath='{.items[0].metadata.name}')

if [ $1 == "basic" ]
  then
    while true
    do
      curl -i -k -H 'x-limited-user: false' https://$AMBASSADOR_IP/qotm/limited/
      sleep 1
    done
elif [ $1 == "global" ]
  then
    while true
    do
      echo -e "\033[0;31mLIMITED USER"
      curl -k -i -H 'x-limited-user: true' https://$AMBASSADOR_IP/qotm/open/
      sleep .3

      echo -e "\033[0;32mUNLIMITED USER"
      curl -k -i -H 'x-limited-user: false' https://$AMBASSADOR_IP/qotm/open/
      sleep .3

      echo -e "\033[0;32mUNLIMITED USER"
      curl -k -i -H 'x-limited-user: false' https://$AMBASSADOR_IP/httpbin-limited/ip
      sleep .3

      echo -e "\033[0;31mLIMITED USER"
      curl -k -i -H 'x-limited-user: true' https://$AMBASSADOR_IP/httpbin-limited/ip
      sleep .3
    done
elif [ $1 == "local-user" ]
  then
    while true
    do
      curl -i -k -H "x-limited-user: false" https://$AMBASSADOR_IP/httpbin/ip
      sleep .5
    done
elif [ $1 == "remote-user" ]
  then
    while true
    do
      kubectl exec -it $AMBASSADOR_POD -c ambassador -- curl -i -k -H "x-limited-user: false" https://ambassador/httpbin/ip
      sleep .5
    done
      
fi