# network-aws module

Creates a standard network in AWS that includes:

- One VPC
- Three public subnets
- Three private subnets
- One NAT Gateway in each public subnet
- One bastion host in each public subnet with Consul, Vault, and Nomad agents installed

This module requires a pre-existing AWS SSH key pair for each bastion host.

## Environment Variables

- `AWS_DEFAULT_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Required Terraform Variables

- `name`
- `ssh_key_name`

## Optional Terraform Variables

- `vpc_cidr`
- `vpc_cidrs_public`
- `vpc_cidrs_private`
- `os`
- `os_version`
- `consul_version`
- `vault_version`
- `nomad_version`
- `bastion_instance_type`

## Outputs

- `vpc_id`
- `subnet_public_ids`
- `subnet_private_ids`
- `security_group_egress_id`
- `security_group_bastion_id`
- `bastion_ips_public`
- `bastion_username`
