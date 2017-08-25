resource "random_id" "name" {
  byte_length = 4
  prefix      = "${var.name}-"
}

module "ssh-keypair-aws" {
  source       = "git@github.com:hashicorp-modules/ssh-keypair-aws.git"
  ssh_key_name = "${random_id.name.hex}"
}

module "network-aws" {
  source = "git@github.com:hashicorp-modules/network-aws.git"

  name         = "${var.name}"
  ssh_key_name = "${module.ssh-keypair-aws.ssh_key_name}"
}
