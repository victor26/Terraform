terraform {
  backend "s3" {
    bucket = "teste-api-26"
    key    = "Prod/terraform.tfstat"
    region = "us-west-2"
  }
}