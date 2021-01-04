terraform {
  backend "gcs" {
    bucket  = "tfstate-bucket-for-cicd-test"
    prefix  = "terraform/tfstate"
  }
}

