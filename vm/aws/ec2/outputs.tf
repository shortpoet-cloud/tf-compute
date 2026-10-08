output "ami" {
  description = "The Amazon Linux AMI the instance runs."
  value       = data.aws_ami.amazon_linux
}

output "subnet" {
  description = "The subnet the instance is placed in."
  value       = data.aws_subnet.subnet
}
output "sgs" {
  description = "The security groups looked up by name."
  value       = data.aws_security_group.sg
}
output "sg_ids" {
  description = "Ids of the security groups attached to the instance."
  value       = local.sg_ids
}
output "ec2" {
  description = "The EC2 instance's id, ARN, type, AMI and IP addresses."
  value = {
    id            = aws_instance.ec2.id
    arn           = aws_instance.ec2.arn
    instance_type = aws_instance.ec2.instance_type
    ami           = aws_instance.ec2.ami
    private_ip    = aws_instance.ec2.private_ip
    public_ip     = aws_instance.ec2.public_ip
  }
}
