terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.52.0"
    }
  }
  required_version = ">= 0.13"
}

provider "google" {
  project = "shortpoet"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_service_account_access_token" "default" {
  target_service_account = local.storage_admin_service_account_email
  scopes = [
    "userinfo-email",
    "cloud-platform",
  ]
  lifetime = "300s"
}

provider "google" {
  project      = "shortpoet"
  alias        = "impersonated"
  access_token = data.google_service_account_access_token.default.access_token
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}
