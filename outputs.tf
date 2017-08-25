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

output "security_group_egress_id" {
  value = "${aws_security_group.egress_public.id}"
}

output "security_group_bastion_id" {
  value = "${aws_security_group.bastion_ssh.id}"
}

output "bastion_username" {
  value = "${lookup(var.user, var.os)}"
}

output "bastion_ips_public" {
  value = ["${aws_instance.bastion.*.public_ip}"]
}
