#!/bin/bash

echo "Set variables"
instance_id="$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"
local_ipv4="$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"

echo "Set hostname"
hostnamectl set-hostname "${hostname}"

if [ "${join_consul}" = false ] ; then
  echo "Exit early if there is no Consul cluster to join"
  exit 0
fi

echo "Configure Consul"
cat <<EOF >/etc/consul.d/consul-client.json
{
  "datacenter": "${environment}",
  "advertise_addr": "$${local_ipv4}",
  "data_dir": "/opt/consul/data",
  "client_addr": "0.0.0.0",
  "log_level": "INFO",
  "ui": true,
  "retry_join": ["provider=aws tag_key=Environment-Name tag_value=${environment}"]
}
EOF

echo "Update configuration file permissions"
chown -R consul:consul /etc/consul.d
chmod -R 0644 /etc/consul.d/*

echo "Don't start Consul in -dev mode"
echo '' | sudo tee /etc/consul.d/consul.conf

echo "Restart Consul"
systemctl restart consul

echo "Configure VAULT_ADDR environment variable to point to remote Vault cluster"
echo 'VAULT_ADDR="https://vault.service.consul:8200"' | sudo tee -a /etc/vault.d/vault.conf

echo "Restart Vault"
systemctl restart vault

echo "Configure NOMAD_ADDR environment variable to point to remote Nomad cluster"
echo 'NOMAD_ADDR="https://nomad.service.consul:4646"' | sudo tee -a /etc/nomad.d/nomad.conf

echo "Restart Nomad"
systemctl restart nomad
