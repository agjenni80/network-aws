# network-aws module

Creates a standard VPC that includes:

- Three public subnets
- Three private subnets
- One NAT Gateway in each public subnet
- One bastion host in each public subnet with Consul, Vault, and Nomad agents installed

## Requirements

This module requires a pre-existing AWS key pair to install on each bastion host.

### Environment Variables

- `AWS_DEFAULT_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### Required Terraform Variables

You must pass the following Terraform variables during `terraform apply` or
in a `terraform.tfvars` file. Examples below:

- `name`
- `os`
- `os_version`
- `ssh_key_name`

### Optional Terraform Variables

You must pass the following Terraform variables during `terraform apply` or
in a `terraform.tfvars` file. Examples below:

- `vpc_cidr`
- `vpc_cidrs_public`
- `vpc_cidrs_private`
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
- `bastion_username`
- `bastion_ips_public`
