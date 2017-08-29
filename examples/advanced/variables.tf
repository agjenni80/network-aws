variable "name"                  { }
variable "rsa_bits"              { }
variable "vpc_cidr"              { }
variable "vpc_cidrs_public"      { type = "list" }
variable "vpc_cidrs_private"     { type = "list" }
variable "environment"           { }
variable "os"                    { }
variable "os_version"            { }
variable "consul_version"        { }
variable "vault_version"         { }
variable "nomad_version"         { }
variable "bastion_instance_type" { }
