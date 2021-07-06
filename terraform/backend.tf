terraform {
  backend "s3" {
    bucket = "epam-task-terraform-backend"
    key    = "task/terraform.tfstate"
    region = "us-east-2"
    access_key = "AKIAURX525MLMMJVVUFU"
    secret_key ="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"
  }
}
