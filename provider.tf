# terraform provider
terraform {
  required_providers {
    helm       = "~> 2.0"
    kubernetes = "~> 2.0"  
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
  }
  required_version = ">= 0.13"
}
# configure backend
terraform {
  backend "local" {
    path = "scw.tfstate"
  }
}
