module "network-aws" {
  source = "git@github.com:hashicorp-modules/network-aws.git"

  name         = "${var.name}"
  os           = "${var.os}"
  os_version   = "${var.os_version}"
  ssh_key_name = "${var.ssh_key_name}"
}
