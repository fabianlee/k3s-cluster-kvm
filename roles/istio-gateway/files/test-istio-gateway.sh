#!/bin/bash
#
# Test istion ingress gateway and certs
#

if [ "$#" -lt 2 ]; then
  echo "Usage: gatewayip-ext fqdn1,fqdn2 [gatewayip-int fqdn]"
  echo "Example: 10.152.183.138 microk8s-1.local,microk8s-alt.local 10.152.183.129 microk8s-secondary.local"
  exit 1
fi
gwextip="$1"
gwextfqdnlist="$2"
gwintip="$3"
gwintfqdn="$4"


# calls curl without proxy (-x) and with --resolve for proper Host header
function call_curl() {
  gateway="$1"
  domain="$2"
  protocol="$3"
  page="$4"
  port="$5"
  expectSuccess="$6"
  if [ -z "$port" ]; then
    if [[ $protocol == "http" ]]; then
      port=80
    elif [[ $protocol == "https" ]]; then
      port=443
    fi
  fi
  if [[ -z $expectSuccess ]]; then
    expectSuccess=0
  fi

  echo "[ $protocol://$domain:$port/$page ]"

  #set -x
  curl --insecure --fail --resolve $domain:$port:$gateway -x '' $protocol://$domain:$port/$page
  retVal=$?
  #set +x

  # is this what we wanted?
  if [[ $retVal -eq 0 && $expectSuccess -eq 0 ]]; then
    echo "OK $retVal was expected success"
  elif [[ $retVal -gt 0 && $expectSuccess -gt 0 ]]; then
    echo "OK $retVal was expected failure"
  else
    echo "ERROR exit code $retVal was not expected"
    exit 9
  fi
  
}

firstCN=""
IFS=','
for domain in $gwextfqdnlist ; do

  # save first domain as CN, for use later
  if [ -z "$firstCN" ]; then
    firstCN=$domain
  fi

  echo ""; echo "";
  echo "***Correct Host header $domain to external $gwextip**********************************************"
  call_curl $gwextip $domain http "hello" 80 0
  call_curl $gwextip $domain https "hello" 443 0
done

# if argument 3 and 4 not provided, then exit normally
if [ "$#" -lt 4 ]; then
  exit 0
fi

echo ""; echo "";
domain=$gwintfqdn
echo "***Incorrect Host header $domain to external $gwextip**********************************************"
call_curl $gwextip $domain http "hello" 80 1
call_curl $gwextip $domain https "hello" 443 1


echo ""; echo "";
echo "***Correct Host header $domain to internal $gwintip**********************************************"
call_curl $gwintip $domain http "hello" 80 0
call_curl $gwintip $domain https "hello" 443 0


echo ""; echo "";
domain=$firstCN
echo "***Incorrect Host header $domain to internal $gwintip**********************************************"
call_curl $gwintip $domain http "hello" 80 1
call_curl $gwintip $domain https "hello" 443 1


echo "DONE"

