module "ec2_private" {
  source      = "../.."
  subnet_name = "sn-tf-dev-pvt-us-east-1a"
  # sg_names    = ["Public-Web"]
  sg_names        = ["Private-App", "MyIp-Web", "Peer-Tf-Gui"]
  env             = "dev"
  tier            = "private"
  create_key_pair = true
  user_data_path  = "../user-data/user-data-nginx.sh"
}

output "ami" {
  value = module.ec2_private.ami
}
output "subnet" {
  value = module.ec2_private.subnet
}
output "sgs" {
  value = module.ec2_private.sgs
}
output "sg_ids" {
  value = module.ec2_private.sg_ids
}
output "ec2" {
  value = module.ec2_private.ec2
}
