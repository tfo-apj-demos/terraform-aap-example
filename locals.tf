# Define a map or list for VM configuration
locals {
  vm_config = {
    vm1 = {
      hostname         = "web-01"
      ad_domain        = "hashicorp.local"
      backup_policy    = "daily"
      environment      = "dev"
      os_type          = "linux"
      security_profile = "web-server"
      site             = "sydney"
      size             = "medium"
      storage_profile  = "standard"
      tier             = "gold"
    }
    vm2 = {
      hostname         = "db-01"
      ad_domain        = "hashicorp.local"
      backup_policy    = "daily"
      environment      = "dev"
      os_type          = "linux"
      security_profile = "db-server"
      site             = "sydney"
      size             = "large"
      storage_profile  = "standard"
      tier             = "gold"
    }
    vm3 = {
      hostname         = "app-01"
      ad_domain        = "hashicorp.local"
      backup_policy    = "weekly"
      environment      = "test"
      os_type          = "linux"
      security_profile = "app-server"
      site             = "melbourne"
      size             = "small"
      storage_profile  = "standard"
      tier             = "gold"
    }
  }
}