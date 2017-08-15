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

resource "aws_vpc" "my_vpc" {
  cidr_block = "${var.cidr_block}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  tags {
    Name = "Mike's gw"
  }
}

# hmmm the default should be OK
# and it seems to be
#resource "aws_network_acl" "all" {
#   vpc_id = "${aws_vpc.my_vpc.id}"
#    egress {
#        protocol = "-1"
#        rule_no = 2
#        action = "allow"
#        cidr_block =  "0.0.0.0/0"
#        from_port = 0
#        to_port = 0
#    }
#    ingress {
#        protocol = "-1"
#        rule_no = 1
#        action = "allow"
#        cidr_block =  "0.0.0.0/0"
#        from_port = 0
#        to_port = 0
#    }
#    tags {
#        Name = "open acl"
#    }
#}

# version a, tested and works
#resource "aws_route_table" "public" {
#  vpc_id = "${aws_vpc.my_vpc.id}"
#  route {
#        cidr_block = "0.0.0.0/0"
#        gateway_id = "${aws_internet_gateway.gw.id}"
#    }
#}

#resource "aws_main_route_table_association" "a" {
#  vpc_id         = "${aws_vpc.my_vpc.id}"
#  route_table_id = "${aws_route_table.public.id}"
#}

# version b
# stolen-ish from the exampes on the terraform site
resource "aws_route" "public_gateway_route" {
  route_table_id = "${aws_vpc.my_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.gw.id}"
}

resource "aws_subnet" "my_subnet" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "${var.subnet}"
}

resource "aws_security_group" "webssh" {
   name = "miketerra-webssh-${var.cluster_name}"
   vpc_id = "${aws_vpc.my_vpc.id}"
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
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.my_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.webssh.id}"]
  tags {
    Name = "${var.tag_name}"
  }
}

output "secg" {
  value =  ["${aws_security_group.webssh.id}"]
}
