terraform {
  required_providers {
    aap = {
      source = "ansible/aap"
      version = "~> 1.0.0"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2"
    }
  }
}

provider "aap" {
  insecure_skip_verify = true
}