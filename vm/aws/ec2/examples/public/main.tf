
module "ec2_public_1a" {
  source      = "../.."
  subnet_name = "sn-tf-dev-pub-us-east-1a"
  # sg_names    = ["MyIp-Web"]
  sg_names = ["Public-Web", "MyIp-Web"]
  # sg_names = ["Public-Web"]
  env             = "dev"
  tier            = "public"
  create_key_pair = false
  user_data_path  = "../user-data/user-data-nginx.sh"
}
module "ec2_public_1b" {
  source      = "../.."
  subnet_name = "sn-tf-dev-pub-us-east-1b"
  # sg_names    = ["MyIp-Web"]
  sg_names = ["Public-Web", "MyIp-Web"]
  # sg_names = ["Public-Web"]
  env             = "dev"
  tier            = "public"
  create_key_pair = false
  user_data_path  = "../user-data/user-data-nginx.sh"
}

# output "ami" {
#   value = module[*].ami
# }
# output "subnet" {
#   value = module[*].subnet
# }
# output "sgs" {
#   value = module[*].sgs
# }
# output "sg_ids" {
#   value = module[*].sg_ids
# }
output "ec2_ips" {
  value = {
    public_1a = module.ec2_public_1a.ec2.public_ip
    public_1b = module.ec2_public_1b.ec2.public_ip
  }
}
