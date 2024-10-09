# Iterate over each VM config to create instances of the module
module "single_virtual_machine" {
  for_each = local.vm_config

  source  = "app.terraform.io/tfo-apj-demos/single-virtual-machine/vsphere"
  version = "~> 1"

  hostname         = each.value.hostname
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

resource "aap_inventory" "vm_inventory" {
  name        = "GCVE VM Inventory"
  description = "Inventory for deployed virtual machines in GCVE"
  variables   = jsonencode({ "os" : "Linux", "automation" : "ansible" })  # Add any relevant inventory-wide variables here
}

resource "aap_group" "vm_groups" {
  for_each = { for key, vm in local.vm_config : vm.security_profile => vm if length(vm.security_profile) > 0 }
  
  inventory_id = aap_inventory.vm_inventory.id
  name         = each.key  # The group name will be the security profile (e.g., web-server, db-server)
  variables    = jsonencode({ "environment" : each.value.environment, "site" : each.value.site })
}

resource "aap_host" "vm_hosts" {
  for_each = local.vm_config

  inventory_id = aap_inventory.vm_inventory.id
  name         = each.value.hostname  # Use the hostname for each VM
  variables    = jsonencode({
    "backup_policy"    : each.value.backup_policy,
    "os_type"          : each.value.os_type,
    "storage_profile"  : each.value.storage_profile,
    "tier"             : each.value.tier
  })
  
  # Associate each host with its respective group based on security profile
  groups = [aap_group.vm_groups[each.value.security_profile].id]
}