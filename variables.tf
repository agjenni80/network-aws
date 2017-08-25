variable "name" {
  description = "Name"
}

variable "ssh_key_name" {
  description = "AWS key name you will use to access the instance(s)"
}

variable "vpc_cidr" {
  default     = "10.139.0.0/16"
  description = "VPC CIDR block"
}

variable "vpc_cidrs_public" {
  default     = [
    "10.139.1.0/24",
    "10.139.2.0/24",
    "10.139.3.0/24",
  ]
  description = "VPC CIDR blocks for public subnets"
}

variable "vpc_cidrs_private" {
  default     = [
    "10.139.11.0/24",
    "10.139.12.0/24",
    "10.139.13.0/24",
  ]
  description = "VPC CIDR blocks for private subnets"
}

variable "environment" {
  default     = "production"
  description = "Environment AMI tag (e.g. development, stage, or production)"
}

variable "os" {
  default     = "RHEL"
  description = "Operating System to use (e.g. RHEL or Ubuntu - case sensitive)"
}

variable "os_version" {
  default     = "7.3"
  description = "Operating System version to use (e.g. 7.3 for RHEL or 16.04 for Ubuntu)"
}

variable "consul_version" {
  default     = "0.9.2"
  description = "Version of Consul to use (e.g. 0.9.2 or 0.9.2+ent)"
}

variable "vault_version" {
  default     = "0.8.1"
  description = "Version of Vault to use (e.g. 0.8.1 or 0.8.1+ent)"
}

variable "nomad_version" {
  default     = "0.6.0"
  description = "Version of Nomad to use (e.g. 0.6.0 or 0.6.0+ent)"
}

variable "bastion_instance_type" {
  default     = "t2.small"
  description = "Instance type of the bastion host"
}
