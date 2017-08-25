output "vpc_cidr_block" {
  value = "${module.network-aws.vpc_cidr_block}"
}

output "vpc_id" {
  value = "${module.network-aws.vpc_id}"
}

output "subnet_public_ids" {
  value = "${module.network-aws.subnet_public_ids}"
}

output "subnet_private_ids" {
  value = "${module.network-aws.subnet_private_ids}"
}

output "security_group_egress_id" {
  value = "${module.network-aws.security_group_egress_id}"
}

output "security_group_bastion_id" {
  value = "${module.network-aws.security_group_bastion_id}"
}

output "bastion_username" {
  value = "${module.network-aws.bastion_username}"
}

output "bastion_ips_public" {
  value = "${module.network-aws.bastion_ips_public}"
}
