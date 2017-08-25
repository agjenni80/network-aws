variable "name" {
  description = "Name"
}

variable "vpc_cidr" {
  default = "172.19.0.0/16"
}

variable "vpc_cidrs_public" {
  default = [
    "172.19.0.0/20",
    "172.19.16.0/20",
    "172.19.32.0/20",
  ]
}

variable "vpc_cidrs_private" {
  default = [
    "172.19.48.0/20",
    "172.19.64.0/20",
    "172.19.80.0/20",
  ]
}

variable "os" {
  description = "Operating System to use ie RHEL or Ubuntu (case sensitive)"
}

variable "os_version" {
  description = "Operating System version to use ie 7.3 (for RHEL) or 16.04 (for Ubuntu)"
}

variable "consul_version" {
  description = "Consul version to use eg 0.8.4 or 0.8.4+ent"
}

variable "vault_version" {
  description = "Vault version to use eg 0.7.3 or 0.7.3+ent"
}

variable "nomad_version" {
  description = "Nomad version to use eg 0.6.0 or 0.6.0+ent"
}

variable "bastion_instance_type" {
  default = "t2.small"
}

variable "ssh_key_name" {
  description = "Pre-existing AWS key name you will use to access the instance(s)"
}
