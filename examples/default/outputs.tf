output "vpc_cidr_block" {
  value = "${module.network_aws.vpc_cidr_block}"
}

output "vpc_id" {
  value = "${module.network_aws.vpc_id}"
}

output "subnet_public_ids" {
  value = "${module.network_aws.subnet_public_ids}"
}

output "subnet_private_ids" {
  value = "${module.network_aws.subnet_private_ids}"
}

output "security_group_egress_id" {
  value = "${module.network_aws.security_group_egress_id}"
}

output "security_group_bastion_id" {
  value = "${module.network_aws.security_group_bastion_id}"
}

output "bastion_username" {
  value = "${module.network_aws.bastion_username}"
}

output "bastion_ips_public" {
  value = "${module.network_aws.bastion_ips_public}"
}

output "_instructions" {
  value = <<BASTION_INSTRUCTIONS
Your AWS network infrastructure has been successfully provisioned!

SSH into a Bastion host by running one of the below commands:
  ${join("\n  ", formatlist("ssh-add %s && ssh -A -i %s %s@%s", module.ssh_keypair_aws.private_key_filename, module.ssh_keypair_aws.private_key_filename, module.network_aws.bastion_username, module.network_aws.bastion_ips_public))}
BASTION_INSTRUCTIONS
}
