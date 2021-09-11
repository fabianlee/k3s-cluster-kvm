#!/bin/bash
#
# creates microk8s.local and microk8s-secondary.local self signed certificates for testing
# microk8s primary and secondary ingress endpoints
#

# make sure package is installed
# older
sudo apt-get install libssl1.0.0 -y
# newer like Ubuntu20 focal
sudo apt-get install libssl1.1 -y

certs="$1"
if [ -z "$certs" ]; then
  certs="microk8s.local microk8s-secondary.local"
fi
echo "going to create certs: $certs"

pushd . > /dev/null

cd /tmp
for FQDN in $certs;  do 

  # create self-signed cert
  sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout $FQDN.key -out $FQDN.crt \
  -subj "/C=US/ST=CA/L=SFO/O=myorg/CN=$FQDN"

  # create pem which contains key and cert
  cat $FQDN.crt $FQDN.key | sudo tee -a $FQDN.pem

  # smoke test, view CN
  openssl x509 -noout -subject -in $FQDN.crt
done

sudo chown $USER /tmp/$FQDN.{pem,crt,key}

popd

