#!/bin/bash
# https://www.terraform.io/downloads.html
# https://www.terraform.io/docs/cli/install/apt.html

set -x

sudo apt-get install jq unzip -y

# explicitly choose version OR pull latest using github api
export TERRA_VERSION=$(curl -sL https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r ".tag_name" | cut -c2-)

# download
wget -4 https://releases.hashicorp.com/terraform/${TERRA_VERSION}/terraform_${TERRA_VERSION}_linux_amd64.zip

# unzip
unzip terraform_${TERRA_VERSION}_linux_amd64.zip

# set permissions and move into path
chmod +x terraform
sudo mv terraform /usr/local/bin

# validate
terraform version
