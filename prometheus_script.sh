#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Please, provide some parameters"
    exit 1
fi

# Rendering variable
download_prom_endpoint=$1
install_location="${2:-/ec2-machine/}"

# Get into the ec2-machine
echo "SSH-ing into machine"
$install_location

# download prom .tar binary
echo "Downloading Prometheus binary file"
wget $download_prom_endpoint

# Unpack the binary
tar xvf prometheus-2.47.2.linux-amd64.tar.gz

# Execute Prometheus
cd prometheus-2.47.2.linux-amd64
./prometheus
