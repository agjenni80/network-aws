variable "name" {
  default     = "network-aws"
  description = "Name for resources, defaults to \"network-aws\"."
}

variable "vpc_cidr" {
  default     = "10.139.0.0/16"
  description = "VPC CIDR block, defaults to \"10.139.0.0/16\"."
}

variable "vpc_cidrs_public" {
  type        = "list"
  default     = ["10.139.1.0/24", "10.139.2.0/24", "10.139.3.0/24",]
  description = "VPC CIDR blocks for public subnets, defaults to \"10.139.1.0/24\", \"10.139.2.0/24\", and \"10.139.3.0/24\"."
}

variable "nat_count" {
  default     = "-1"
  description = "Number of NAT gateways to provision across public subnets, defaults to public subnet count."
}

variable "vpc_cidrs_private" {
  type        = "list"
  default     = ["10.139.11.0/24", "10.139.12.0/24", "10.139.13.0/24",]
  description = "VPC CIDR blocks for private subnets, defaults to \"10.139.11.0/24\", \"10.139.12.0/24\", and \"10.139.13.0/24\"."
}

variable "release_version" {
  default     = "0.1.0-dev1"
  description = "Release version tag (e.g. 0.1.0, 0.1.0-rc1, 0.1.0-beta1, 0.1.0-dev1), defaults to \"0.1.0-dev1\""
}

variable "consul_version" {
  default     = "0.9.2"
  description = "Consul version tag (e.g. 0.9.2 or 0.9.2-ent), defaults to \"0.9.2\"."
}

variable "vault_version" {
  default     = "0.8.1"
  description = "Vault version tag (e.g. 0.8.1 or 0.8.1-ent), defaults to \"0.8.1\"."
}

variable "nomad_version" {
  default     = "0.6.2"
  description = "Nomad version tag (e.g. 0.6.2 or 0.6.2-ent), defaults to \"0.6.2\"."
}

variable "os" {
  default     = "RHEL"
  description = "Operating System (e.g. RHEL or Ubuntu), defaults to \"RHEL\"."
}

variable "os_version" {
  default     = "7.3"
  description = "Operating System version (e.g. 7.3 for RHEL or 16.04 for Ubuntu), defaults to \"7.3\"."
}

variable "bastion_count" {
  default     = "-1"
  description = "Number of bastion hosts to provision across public subnets, defaults to public subnet count."
}

variable "image_id" {
  default     = ""
  description = "AMI to use, defaults to the HashiStack AMI."
}

variable "instance_profile" {
  default     = ""
  description = "AWS instance profile to use, defaults to consul-auto-join-instance-role module."
}

variable "instance_type" {
  default     = "t2.small"
  description = "AWS instance type for bastion host (e.g. m4.large), defaults to \"t2.small\"."
}

variable "user_data" {
  default     = ""
  description = "user_data script to pass in at runtime."
}

variable "ssh_key_name" {
  default     = ""
  description = "AWS key name you will use to access the Bastion host instance(s), defaults to generating an SSH key for you."
}

variable "ssh_key_override" {
  default     = ""
  description = "Override the default SSH key and pass in your own."
}

variable "users" {
  default = {
    RHEL   = "ec2-user"
    Ubuntu = "ubuntu"
  }

  description = "Map of SSH users."
}
