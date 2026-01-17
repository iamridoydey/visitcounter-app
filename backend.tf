terraform {
  backend "s3" {
    bucket = "projects-state-files"
    key    = "visitcounter.terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}
