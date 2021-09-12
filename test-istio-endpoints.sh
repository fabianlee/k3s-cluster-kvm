#!/bin/bash

curlopt="-k --fail --connect-timeout 3 --retry 0"
while [ 1==1 ]; do 
  timestamp=$(date +"%D %T")
  echo ""
  echo "$timestamp"
  curl $curlopt https://k3s.local/hello
  curl $curlopt https://k3s-secondary.local/hello
  sleep 4
done
