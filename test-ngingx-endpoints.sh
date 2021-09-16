#!/bin/bash

for h in k3s.local k3s-secondary.local; do
  nslookup -timeout=1 $h
  if [ $? -ne 0 ]; then
    echo "WARN are you sure $h is DNS resolvable? did you add it to /etc/hosts?"
    #exit 3
  fi
done

curlopt="-k --fail --connect-timeout 3 --retry 0"
while [ 1==1 ]; do 
  timestamp=$(date +"%D %T")
  echo ""
  echo "$timestamp"
  curl $curlopt https://k3s.local/myhello/
  curl $curlopt https://k3s-secondary.local/myhello2/
  sleep 4
done
