resource "random_id" "name" {
  byte_length = 4
  prefix      = "${var.environment}-"
}

module "ssh_keypair_aws" {
  source = "../../../ssh-keypair-aws"
  # source = "git@github.com:hashicorp-modules/ssh-keypair-aws.git?ref=f-refactor"

  ssh_key_name = "${random_id.name.hex}"
}

module "network_aws" {
  source = "../../../network-aws"
  # source = "git@github.com:hashicorp-modules/network-aws.git?ref=f-refactor"

  environment  = "${var.environment}"
  ssh_key_name = "${module.ssh_keypair_aws.ssh_key_name}"
}
