terraform {
  backend "s3" {
    bucket       = "prod-terraform-state-bucket-m0dd"
    key          = "eks/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
