# Output the virtual_machine_name for all instances
output "virtual_machine_names" {
  value = {
    for vm_key, vm_value in module.single_virtual_machine :
    vm_key => vm_value.virtual_machine_name
  }
}

locals {
  # Build a list of IP addresses from each module instance
  vm_ip_addresses = [for vm in values(module.single_virtual_machine) : vm.ip_address]

  # Check that each VM has a valid (non-null, non-empty) IP address
  all_vms_have_ip = length([for ip in local.vm_ip_addresses : ip if ip != null && ip != ""]) == length(var.vm_config)
}

output "vm_ip_addresses" {
  value = local.vm_ip_addresses
}

output "all_vms_have_ip" {
  value = local.all_vms_have_ip
}

# output "ansible_inventory" {
#   value = {
#     for key, vm in var.vm_config :
#     key => {
#       "hostname"         = vm.hostname
#       "security_profile" = vm.security_profile
#       "group"            = aap_group.vm_groups[vm.security_profile].name
#       "variables"        = {
#         "backup_policy"    : vm.backup_policy,
#         "os_type"          : vm.os_type,
#         "storage_profile"  : vm.storage_profile,
#         "tier"             = vm.tier
#       }
#     }
#   }
# }
