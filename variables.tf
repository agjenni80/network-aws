variable "environment" {
  description = "Environment name."
}

variable "vpc_cidr" {
  default     = "10.139.0.0/16"
  description = "VPC CIDR block."
}

variable "vpc_cidrs_public" {
  type        = "list"
  default     = ["10.139.1.0/24", "10.139.2.0/24", "10.139.3.0/24",]
  description = "VPC CIDR blocks for public subnets."
}

variable "vpc_cidrs_private" {
  type        = "list"
  default     = [ "10.139.11.0/24", "10.139.12.0/24", "10.139.13.0/24",]
  description = "VPC CIDR blocks for private subnets."
}

variable "release_version" {
  default     = "0.1.0-dev1"
  description = "Release version tag (e.g. 0.1.0, 0.1.0-rc1, 0.1.0-beta1, 0.1.0-dev1)"
}

variable "consul_version" {
  default     = "0.9.2"
  description = "Consul version tag (e.g. 0.9.2 or 0.9.2-ent)."
}

variable "vault_version" {
  default     = "0.8.1"
  description = "Vault version tag (e.g. 0.8.1 or 0.8.1-ent)."
}

variable "nomad_version" {
  default     = "0.6.2"
  description = "Nomad version tag (e.g. 0.6.2 or 0.6.2-ent)."
}

variable "os" {
  default     = "RHEL"
  description = "Operating System (e.g. RHEL or Ubuntu)."
}

variable "os_version" {
  default     = "7.3"
  description = "Operating System version (e.g. 7.3 for RHEL or 16.04 for Ubuntu)."
}

variable "nat_count" {
  default     = "0"
  description = "Number of NAT gateways to provision across public subnets, defaults to public subnet count."
}

variable "bastion_count" {
  default     = "0"
  description = "Number of bastion hosts to provision across public subnets, defaults to public subnet count."
}

variable "instance_type" {
  default     = "t2.small"
  description = "AWS instance type for bastion host (e.g. m4.large)."
}

variable "join_consul" {
  default     = "true"
  description = "Join a Consul cluster with the local Consul agent."
}

variable "ssh_key_name" {
  description = "AWS key name you will use to access the instance(s)."
}

variable "user" {
  default = {
    RHEL   = "ec2-user"
    Ubuntu = "ubuntu"
  }

  description = "Map of SSH users."
}
