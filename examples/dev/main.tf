module "network_aws" {
  source = "../../../network-aws"
  # source = "github.com/hashicorp-modules/network-aws?ref=f-refactor"

  name              = "${var.name}"
  vpc_cidrs_public  = "${var.vpc_cidrs_public}"
  nat_count         = "${var.nat_count}"
  vpc_cidrs_private = "${var.vpc_cidrs_private}"
  bastion_count     = "${var.bastion_count}"
}
