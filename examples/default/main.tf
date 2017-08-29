resource "random_id" "name" {
  byte_length = 4
  prefix      = "${var.name}-"
}

module "ssh_keypair_aws" {
  # source = "git@github.com:hashicorp-modules/ssh-keypair-aws.git?ref=f-refactor"
  source = "../../../ssh-keypair-aws"

  ssh_key_name = "${random_id.name.hex}"
}

module "network_aws" {
  # source = "git@github.com:hashicorp-modules/network-aws.git?ref=f-refactor"
  source = "../../../network-aws"

  name         = "${var.name}"
  ssh_key_name = "${module.ssh_keypair_aws.ssh_key_name}"
}
