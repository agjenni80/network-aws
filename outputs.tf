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
  value = "${aws_security_group.bastion.id}"
}

output "bastion_ips_public" {
  value = ["${aws_instance.bastion.*.public_ip}"]
}

output "bastion_username" {
  value = "${lookup(var.users, var.os)}"
}
