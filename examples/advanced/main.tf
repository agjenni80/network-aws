resource "random_id" "name" {
  byte_length = 4
  prefix      = "${var.name}-"
}

module "ssh_keypair_aws" {
  # source = "git@github.com:hashicorp-modules/ssh-keypair-aws.git?ref=f-refactor"
  source = "../../../ssh-keypair-aws"

  ssh_key_name = "${random_id.name.hex}"
  rsa_bits     = "${var.rsa_bits}"
}

module "network_aws" {
  # source = "git@github.com:hashicorp-modules/network-aws.git?ref=f-refactor"
  source = "../../../network-aws"

  name                  = "${var.name}"
  vpc_cidr              = "${var.vpc_cidr}"
  vpc_cidrs_public      = "${var.vpc_cidrs_public}"
  vpc_cidrs_private     = "${var.vpc_cidrs_private}"
  environment           = "${var.environment}"
  os                    = "${var.os}"
  os_version            = "${var.os_version}"
  consul_version        = "${var.consul_version}"
  vault_version         = "${var.vault_version}"
  nomad_version         = "${var.nomad_version}"
  bastion_instance_type = "${var.bastion_instance_type}"
  ssh_key_name          = "${module.ssh_keypair_aws.ssh_key_name}"
}
