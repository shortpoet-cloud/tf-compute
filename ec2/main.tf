terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.13"
}

# data "aws_iam_users" "users" {}

# data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
data "aws_subnet" "subnet" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}
data "aws_security_group" "sg" {
  for_each = { for sg in var.sg_names : sg => sg }
  filter {
    name   = "tag:Name"
    values = [each.value]
  }
}
locals {
  sg_ids          = [for sg in var.sg_names : lookup(data.aws_security_group.sg, sg).id]
  env             = var.env
  region          = data.aws_region.current.name
  ec2_name        = "ec2-tf-${var.env}-${var.tier}-${data.aws_subnet.subnet.availability_zone}"
  create_key_pair = var.create_key_pair
  # key_name = "aws_ec2"
}
# [DescribeSubnets](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeSubnets.html)
# for filter args
# data "aws_security_groups" "sgs" {
#   dynamic "filter" {
#     for_each = var.sg_names
#     content {
#       name   = "tag:Name"
#       values = ["${filter.value}"]
#     }
#   }
# }
# resource "aws_key_pair" "ssh_key" {
#   count    = var.create_key_pair == true ? 1 : 0
#   key_name = local.key_name
#   public_key = file("~/.ssh/id_ed25519-aws_ec2.pub")
#   # lifecycle {
#   #   prevent_destroy = true
#   # }
# }

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  # VPC
  subnet_id = data.aws_subnet.subnet.id
  # Security Group
  vpc_security_group_ids = local.sg_ids
  # the Public SSH key
  # key_name = local.key_name
  # nginx installation
  user_data         = file(var.user_data_path)
  availability_zone = data.aws_subnet.subnet.availability_zone
  metadata_options {
    instance_metadata_tags = "enabled"
    http_endpoint          = "enabled"
  }
  # user_data = file("./examples/user-data/user-data-nginx.sh")
  tags = {
    Name        = local.ec2_name
    SSH         = local.create_key_pair == true ? "true" : "false"
    Type        = "ec2"
    SubType     = "instance"
    Environment = local.env
    Region      = local.region
  }
  # depends_on = [
  #   aws_key_pair.ssh_key
  # ]
  # provisioner "file" {
  #   source      = "nginx.sh"
  #   destination = "/tmp/nginx.sh"
  # }
  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/nginx.sh",
  #     "sudo /tmp/nginx.sh"
  #   ]
  # }
  # connection {
  #   user        = var.EC2_USER
  #   private_key = file("${var.PRIVATE_KEY_PATH}")
  # }
}
