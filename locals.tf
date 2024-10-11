# Define a map or list for VM configuration
locals {
  vm_names = for vm_key, vm_value in module.single_virtual_machine : vmkey => vm_value.virtual_machine_name
}