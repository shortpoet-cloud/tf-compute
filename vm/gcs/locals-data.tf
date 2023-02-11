# data "google_project" "project" {}
locals {
  # project_id                          = data.google_project.project.project_id
  storage_admin_service_account_email = "tf-sa-storage-admin@shortpoet.iam.gserviceaccount.com"
}
