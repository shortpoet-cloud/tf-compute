output "ami" {
  value = data.aws_ami.amazon_linux
}

output "subnet" {
  value = data.aws_subnet.subnet

}
output "sgs" {
  value = data.aws_security_group.sg
}
output "sg_ids" {
  value = local.sg_ids
}
output "ec2" {
  value = aws_instance.ec2
}
