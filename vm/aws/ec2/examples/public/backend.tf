terraform {
  # backend "local" {

  # }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "sp-aws"
    workspaces {
      name = "ec2-fcc-pub-dev-us-east-1"
    }
  }
}
