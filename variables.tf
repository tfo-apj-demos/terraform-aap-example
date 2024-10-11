variable "TFC_WORKSPACE_ID" {}

# variable "domain" {
#   description = "The Active Directory domain for the VMs."
#   type        = string
# }

variable "job_template_id" {
  description = "The ID of the job template to run."
  type        = string
  default = "9"
}

variable "vm_config" {
  description = "Configuration for multiple VMs"
  type = map(object({
    hostname         = string
    ad_domain        = string
    backup_policy    = string
    environment      = string
    os_type          = string
    security_profile = string
    site             = string
    size             = string
    storage_profile  = string
    tier             = string
  }))

  default = {
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