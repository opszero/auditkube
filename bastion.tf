resource "aws_eip" "bastion_eip" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true
}

data "aws_ami" "opszero_eks" {
  most_recent = true

  filter {
    name   = "name"
    values = ["opszero-eks-*"]
  }

  owners = ["self"]
}

resource "aws_instance" "bastion" {
  ami           = "${data.aws_ami.opszero_eks.id}"
  instance_type = "t2.micro"

  key_name                    = "${var.ec2_keypair}"
  associate_public_ip_address = true
  subnet_id                   = "subnet-92366ef5"
  vpc_security_group_ids      = ["sg-300d724b", "sg-9a0f70e1"]

  tags = {
    Name = "${var.cluster-name}-bastion"
  }
}

# resource "aws_security_group_rule" "opszero_workstation" {
#   cidr_blocks       = ["${}"]
#   description       = "Allow workstation to communicate with the cluster API Server"
#   from_port         = 443
#   protocol          = "tcp"
#   security_group_id = "${aws_security_group.cluster.id}"
#   to_port           = 443
#   type              = "ingress"
# }
