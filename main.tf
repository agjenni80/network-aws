terraform {
  required_version = ">= 0.9.3"
}

data "aws_availability_zones" "main" {}

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.environment}"
  }
}

resource "aws_subnet" "public" {
  count = "${length(var.vpc_cidrs_public)}"

  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${element(data.aws_availability_zones.main.names, count.index)}"
  cidr_block              = "${element(var.vpc_cidrs_public, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.environment}-public-${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.environment}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "${var.environment}-public"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(var.vpc_cidrs_public)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_eip" "nat" {
  count = "${var.nat_count ? var.nat_count : length(var.vpc_cidrs_public)}"

  vpc = true
}

resource "aws_nat_gateway" "nat" {
  count = "${var.nat_count ? var.nat_count : length(var.vpc_cidrs_public)}"

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
    Name = "${var.environment}-private-${count.index}"
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
    Name = "${var.environment}-private-subnet-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(var.vpc_cidrs_private)}"

  subnet_id      = "${element(aws_subnet.private.*.id,count.index)}"
  route_table_id = "${element(aws_route_table.private_subnet.*.id,count.index)}"
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

data "template_file" "bastion_init" {
  count    = "${var.bastion_count ? var.bastion_count : length(var.vpc_cidrs_public)}"
  template = "${file("${path.module}/templates/init-systemd.sh.tpl")}"

  vars = {
    consul_sg_id = "${var.environment}"
    hostname     = "${var.environment}-bastion-${count.index}"
    join_consul  = "${var.join_consul}"
  }
}

resource "aws_security_group" "bastion_ssh" {
  name        = "${var.environment}-bastion-ssh"
  description = "${var.environment}-bastion-ssh"
  vpc_id      = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "bastion_ssh" {
  security_group_id = "${aws_security_group.bastion_ssh.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "egress_public" {
  name        = "${var.environment}-egress-public"
  description = "${var.environment}-egress-public"
  vpc_id      = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "egress_public" {
  security_group_id = "${aws_security_group.egress_public.id}"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "bastion" {
  count = "${var.bastion_count ? var.bastion_count : length(var.vpc_cidrs_public)}"

  ami           = "${data.aws_ami.hashistack.id}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.ssh_key_name}"
  user_data     = "${element(data.template_file.bastion_init.*.rendered, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  vpc_security_group_ids = [
    "${aws_security_group.egress_public.id}",
    "${aws_security_group.bastion_ssh.id}",
  ]

  tags {
    Name = "${var.environment}-bastion-${count.index}"
    Environment-Name = "${var.environment}"
  }
}
