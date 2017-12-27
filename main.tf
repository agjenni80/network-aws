terraform {
  required_version = ">= 0.9.3"
}

data "aws_availability_zones" "main" {}

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.name}"
  }
}

resource "aws_subnet" "public" {
  count = "${length(var.vpc_cidrs_public)}"

  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${element(data.aws_availability_zones.main.names, count.index)}"
  cidr_block              = "${element(var.vpc_cidrs_public, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.name}-public-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(var.vpc_cidrs_public)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_eip" "nat" {
  count = "${var.nat_count != "-1" ? var.nat_count : length(var.vpc_cidrs_public)}"

  vpc = true
}

resource "aws_nat_gateway" "nat" {
  count = "${var.nat_count != "-1" ? var.nat_count : length(var.vpc_cidrs_public)}"

  allocation_id = "${element(aws_eip.nat.*.id,count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_subnet" "private" {
  count = "${length(var.vpc_cidrs_private)}"

  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${element(data.aws_availability_zones.main.names, count.index)}"
  cidr_block              = "${element(var.vpc_cidrs_private, count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name = "${var.name}-private-${count.index + 1}"
  }
}

resource "aws_route_table" "private_subnet" {
  count = "${length(var.vpc_cidrs_private)}"

  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id,count.index)}"
  }

  tags {
    Name = "${var.name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(var.vpc_cidrs_private)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_subnet.*.id, count.index)}"
}

module "consul_auto_join_instance_role" {
  source = "git@github.com:hashicorp-modules/consul-auto-join-instance-role-aws?ref=f-refactor"

  count = "${var.bastion_count != "0" ? 1 : 0}"
  name  = "${var.name}"
}

data "aws_ami" "hashistack" {
  most_recent = true
  owners      = ["362381645759"] # hc-se-demos Hashicorp SE Demos Account

  filter {
    name   = "tag:System"
    values = ["HashiStack"]
  }

  filter {
    name   = "tag:Product"
    values = ["HashiStack"]
  }

  filter {
    name   = "tag:Release-Version"
    values = ["${var.release_version}"]
  }

  filter {
    name   = "tag:Consul-Version"
    values = ["${var.consul_version}"]
  }

  filter {
    name   = "tag:Vault-Version"
    values = ["${var.vault_version}"]
  }

  filter {
    name   = "tag:Nomad-Version"
    values = ["${var.nomad_version}"]
  }

  filter {
    name   = "tag:OS"
    values = ["${lower(var.os)}"]
  }

  filter {
    name   = "tag:OS-Version"
    values = ["${var.os_version}"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ssh_keypair_aws" {
  source = "git@github.com:hashicorp-modules/ssh-keypair-aws.git?ref=f-refactor"

  # This doesn't set the "key_name" attribute on aws_instance.bastion when uncommented,
  # there always seems to be 1.) a dirty plan that fails to set the value on apply
  # or 2.) the plan fails because of a count interpolation error in the tls-private-key
  # module. Commenting this out just creates an ssh_keypair regardless if one is passed in,
  # so not too big of a deal, worst case scenario is you have an un-used keypair.

  # EDIT: Regarding 1: this was resolved using a concat on module.ssh_keypair_aws.name,
  # regarding 2: When using the "advanced" example and the below argument "count" is uncommented,
  # the variable ${var.ssh_key_name} is computed, throwing the error
  # "value of 'count' cannot be computed". As a workaround, we're passing in a static
  # variable ${var.ssh_key_override} until the below issue is fixed.
  # https://github.com/hashicorp/terraform/issues/12570#issuecomment-310236691
  # https://github.com/hashicorp/terraform/issues/4149
  # https://github.com/hashicorp/terraform/issues/10857
  # https://github.com/hashicorp/terraform/issues/13980
  # count = "${var.ssh_key_name == "" && var.bastion_count != "0" ? 1 : 0}" # TODO: Uncomment once issue #4149 is resolved
  count = "${var.ssh_key_override == "" && var.bastion_count != "0" ? 1 : 0}" # TODO: Remove once issue #4149 is resolved
  name  = "${var.name}"
}

data "template_file" "bastion_init" {
  count    = "${var.bastion_count != "-1" ? var.bastion_count : length(var.vpc_cidrs_public)}"
  template = "${file("${path.module}/templates/init-systemd.sh.tpl")}"

  vars = {
    hostname  = "${var.name}-bastion-${count.index + 1}"
    user_data = "${var.user_data != "" ? var.user_data : "echo No custom user_data"}"
  }
}

module "bastion_consul_client_sg" {
  source = "git@github.com:hashicorp-modules/consul-client-ports-aws?ref=f-refactor"

  count       = "${var.bastion_count != "0" ? 1 : 0}"
  name        = "${var.name}-bastion-consul-client"
  vpc_id      = "${aws_vpc.main.id}"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group" "bastion" {
  count = "${var.bastion_count != "0" ? 1 : 0}"

  name        = "${var.name}-bastion"
  description = "Security Group for ${var.name} Bastion hosts"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}-bastion"
  }
}

resource "aws_security_group_rule" "ssh" {
  count = "${var.bastion_count != "0" ? 1 : 0}"

  security_group_id = "${aws_security_group.bastion.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_public" {
  count = "${var.bastion_count != "0" ? 1 : 0}"

  security_group_id = "${aws_security_group.bastion.id}"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "bastion" {
  count = "${var.bastion_count != "-1" ? var.bastion_count : length(var.vpc_cidrs_public)}"

  # Workaround for https://github.com/hashicorp/terraform/issues/11210
  iam_instance_profile = "${var.instance_profile != "" ? var.instance_profile : element(concat(module.consul_auto_join_instance_role.instance_profile_id, list("")), 0)}" # TODO: Remove concat once issue #11210 is fixed
  ami                  = "${var.image_id != "" ? var.image_id : data.aws_ami.hashistack.id}"
  instance_type        = "${var.instance_type}"
  # Workaround for https://github.com/hashicorp/terraform/issues/11210
  key_name             = "${var.ssh_key_name != "" ? var.ssh_key_name : element(concat(module.ssh_keypair_aws.name, list("")), 0)}" # TODO: Remove concat once issue #11210 is fixed
  user_data            = "${element(data.template_file.bastion_init.*.rendered, count.index)}"
  subnet_id            = "${element(aws_subnet.public.*.id, count.index)}"

  vpc_security_group_ids = [
    "${element(module.bastion_consul_client_sg.consul_client_sg_id, 0)}",
    "${aws_security_group.bastion.id}",
  ]

  tags {
    Name             = "${var.name}-bastion-${count.index + 1}"
    Consul-Auto-Join = "${var.name}"
  }
}
