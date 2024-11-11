terraform {
  required_providers {
    # aap = {
    #   source = "ryancbutler/aap"
    #   version = "~> 0.1.1"
    # }
    aap = {
      source  = "tfo-apj-demos/aap"
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