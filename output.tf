# Output the virtual_machine_name for all instances
output "virtual_machine_names" {
  value = {
    for vm_key, vm_value in module.single_virtual_machine :
    vm_key => vm_value.virtual_machine_name
  }
}

output "ansible_inventory" {
  value = {
    for key, vm in local.vm_config :
    key => {
      "hostname"         = vm.hostname
      "security_profile" = vm.security_profile
      "group"            = aap_group.vm_groups[vm.security_profile].name
      "variables"        = {
        "backup_policy"    : vm.backup_policy,
        "os_type"          : vm.os_type,
        "storage_profile"  : vm.storage_profile,
        "tier"             = vm.tier
      }
    }
  }
}
