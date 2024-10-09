# Output the virtual_machine_name for all instances
output "virtual_machine_names" {
  value = {
    for vm_key, vm_value in module.single_virtual_machine :
    vm_key => vm_value.virtual_machine_name
  }
}
