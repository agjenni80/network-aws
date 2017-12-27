output "vpc_cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "subnet_public_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "subnet_private_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "bastion_security_group" {
  value = "${aws_security_group.bastion.*.id}"
}

output "bastion_ips_public" {
  value = ["${aws_instance.bastion.*.public_ip}"]
}

output "bastion_username" {
  value = "${lookup(var.users, var.os)}"
}

output "private_key_name" {
  value = "${var.ssh_key_name == "" && var.bastion_count != "0" ? join(",", module.ssh_keypair_aws.private_key_name) : join(",", list())}"
}

output "private_key_filename" {
  value = "${var.ssh_key_name == "" && var.bastion_count != "0" ? join(",", module.ssh_keypair_aws.private_key_filename) : join(",", list())}"
}

output "private_key_pem" {
  value = "${var.ssh_key_name == "" && var.bastion_count != "0" ? join(",", module.ssh_keypair_aws.private_key_pem) : join(",", list())}"
}

output "public_key_pem" {
  value = "${var.ssh_key_name == "" && var.bastion_count != "0" ? join(",", module.ssh_keypair_aws.public_key_pem) : join(",", list())}"
}

output "public_key_openssh" {
  value = "${var.ssh_key_name == "" && var.bastion_count != "0" ? join(",", module.ssh_keypair_aws.public_key_openssh) : join(",", list())}"
}

output "ssh_key_name" {
  value = "${var.ssh_key_name == "" && var.bastion_count != "0" ? join(",", module.ssh_keypair_aws.name) : join(",", list())}"
}
