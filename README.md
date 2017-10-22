# AWS Network Terraform Module

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

## Input Variables

- `environment`: [Required] Environment name.
- `vpc_cidr`: [Optional] VPC CIDR block.
- `vpc_cidrs_public`: [Optional] VPC CIDR blocks for public subnets.
- `nat_count`: [Optional] Number of NAT gateways to provision across public subnets, defaults to public subnet count.
- `vpc_cidrs_private`: [Optional] VPC CIDR blocks for private subnets.
- `release_version`: [Optional] Release version tag to use (e.g. 0.1.0, 0.1.0-rc1, 0.1.0-beta1, 0.1.0-dev1).
- `consul_version`: [Optional] Consul version tag to use (e.g. 0.9.2 or 0.9.2-ent).
- `vault_version`: [Optional] Vault version tag to use (e.g. 0.8.1 or 0.8.1-ent).
- `nomad_version`: [Optional] Nomad version tag to use (e.g. 0.6.0 or 0.6.0-ent).
- `os`: [Optional] Operating System to use (e.g. RHEL or Ubuntu).
- `os_version`: [Optional] Operating System version to use (e.g. 7.3 for RHEL or 16.04 for Ubuntu).
- `bastion_count`: [Optional] Number of bastion hosts to provision across public subnets, defaults to public subnet count.
- `bastion_connect`: [Optional] Determines if the Bastion host should attempt join a Consul cluster & configure the Vault & Nomad CLIs to connect to existing clusters.
- `bastion_instance`: [Optional] Instance type of the bastion host.
- `ssh_key_name`: [Required] Name of AWS keypair that will be created.
- `user`: [Optional] Map of SSH users.

## Outputs

- `vpc_cidr_block`: The VPC CIDR block.
- `vpc_id`: The VPC ID.
- `subnet_public_ids`: The public subnet IDs.
- `subnet_private_ids`: The private subnet IDs.
- `security_group_bastion`: The ID of the bastion host security group.
- `bastion_ips_public`: The public IP(s) of the Bastion host(s).
- `bastion_username`: The Bastion host username.

## Module Dependencies

- [AWS SSH Keypair Terraform Module](https://github.com/hashicorp-modules/ssh-keypair-aws)
  - [TLS Private Key Terraform Module](https://github.com/hashicorp-modules/tls-private-key)

## Authors

HashiCorp Solutions Engineering Team.

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
