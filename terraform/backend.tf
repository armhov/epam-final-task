terraform {
  backend "s3" {
    bucket = "epam-task-terraform-backend"
    key    = "task/terraform.tfstate"
    region = "us-east-2"
    shared_credentials_file = "~/.aws/credentials"
  }
}
