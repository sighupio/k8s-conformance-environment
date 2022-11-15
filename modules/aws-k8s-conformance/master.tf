resource "aws_security_group" "master" {
  vpc_id      = data.aws_vpc.vpc.id
  name_prefix = "${var.cluster_name}-master"
}

resource "aws_security_group_rule" "master_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.trusted_cidrs
  security_group_id = aws_security_group.master.id
}

resource "aws_security_group_rule" "master_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.master.id
}

resource "tls_private_key" "master" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "template_file" "init_master" {
  template = file("${path.module}/templates/master.tpl.yaml")
  vars = {
    ssh_authorized_key = tls_private_key.master.public_key_openssh
    cluster_name       = var.cluster_name
    cluster_version    = var.cluster_version
    public_ip          = aws_eip.master.public_ip
    join_token         = "${random_string.firts_part.result}.${random_string.second_part.result}"
    pod_network_cidr   = var.pod_network_cidr
    wait_for_script    = indent(8, file("${path.module}/resources/wait-for.sh"))
  }
}

resource "aws_eip" "master" {
  vpc = true
}

resource "random_string" "firts_part" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "second_part" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_instance" "master" {
  ami                    = lookup(local.ubuntu_amis, var.region, "")
  instance_type          = var.master_instance_type
  subnet_id              = data.aws_subnet.public.id
  vpc_security_group_ids = ["${aws_security_group.master.id}"]
  source_dest_check      = false
  user_data              = data.template_file.init_master.rendered
  root_block_device {
    volume_size = 100
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.master.id
  allocation_id = aws_eip.master.id
}
