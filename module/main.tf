provider "aws" {
  region = "${var.region}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "webssh" {
   name = "miketerra-webssh-${var.cluster_name}"
}

resource "aws_security_group_rule" "webssh_test1" {
     type = "ingress"
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
     security_group_id = "${aws_security_group.webssh.id}"
}

resource "aws_security_group_rule" "webssh_test2" {
     type = "ingress"
     from_port = 443
     to_port = 443
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
     security_group_id = "${aws_security_group.webssh.id}"
}

resource "aws_security_group_rule" "webssh_test3" {
     type = "egress"
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
     security_group_id = "${aws_security_group.webssh.id}"
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "kp1"

  vpc_security_group_ids = ["${aws_security_group.webssh.id}"]
  tags {
    Name = "${var.tag_name}"
  }
}

output "secg" {
  value =  ["${aws_security_group.webssh.id}"]
}