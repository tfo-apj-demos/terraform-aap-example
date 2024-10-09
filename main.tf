# Iterate over each VM config to create instances of the module
module "single_virtual_machine" {
  for_each = local.vm_config

  source  = "app.terraform.io/tfo-apj-demos/single-virtual-machine/vsphere"
  version = "~> 1"

  ad_domain        = each.value.ad_domain
  backup_policy    = each.value.backup_policy
  environment      = each.value.environment
  os_type          = each.value.os_type
  security_profile = each.value.security_profile
  site             = each.value.site
  size             = each.value.size
  storage_profile  = each.value.storage_profile
  tier             = each.value.tier
}