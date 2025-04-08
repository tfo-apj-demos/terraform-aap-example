# Terraform Cloud/Enterprise + Ansible Automation Platform (AAP) Integration Demo

This repository showcases an end-to-end integration between **Terraform** and **Ansible Automation Platform (AAP)**.

## Overview

This demo:

- Deploys vSphere virtual machines using a **private module** from the **Terraform Cloud Private Module Registry**
- Integrates with AAP to:
  - Create dynamic **inventories**, **groups**, and **hosts**
  - Trigger **Ansible jobs** post-VM deployment

## Requirements

- Terraform Cloud account with access to the private module registry
- Ansible Automation Platform (AAP) instance and job template ID
- vSphere credentials and access

## Use Cases

- Automate VM provisioning with post-deployment configuration
- Dynamically populate AAP inventory based on infrastructure state
- Demonstrate Terraform + AAP synergy for automation-first workflows


## Key Components

### ✅ Virtual Machine Deployment

Each VM is deployed **on-prem** to vSphere using the [vsphere provider](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs).  
VM configurations are managed via `for_each` over a `vm_config` variable.

    module "single_virtual_machine" {
      for_each = var.vm_config

      source  = "app.terraform.io/tfo-apj-demos/single-virtual-machine/vsphere"
      version = "~> 1.0"

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

### 🔄 AAP Integration

#### Inventory

Creates a centralized AAP inventory for all deployed VMs.

    resource "aap_inventory" "vm_inventory" {
      name        = "GCVE VM Inventory - ${var.TFC_WORKSPACE_ID}"
      description = "Inventory for deployed virtual machines in GCVE"
      variables   = jsonencode({ "os" : "Linux", "automation" : "ansible" })
    }

#### Groups

Creates AAP groups based on the `security_profile` of each VM.

    resource "aap_group" "vm_groups" {
      for_each = { for key, vm in var.vm_config : vm.security_profile => vm if length(vm.security_profile) > 0 }

      inventory_id = aap_inventory.vm_inventory.id
      name         = replace(each.key, "-", "_")
      variables    = jsonencode({ "environment" : each.value.environment, "site" : each.value.site })
    }

#### Hosts

Maps each VM to a host entry in AAP, with relevant metadata and group associations.

    resource "aap_host" "vm_hosts" {
      for_each = var.vm_config

      inventory_id = aap_inventory.vm_inventory.id
      name         = each.value.hostname
      variables    = jsonencode({
        "backup_policy"    : each.value.backup_policy,
        "os_type"          : each.value.os_type,
        "storage_profile"  : each.value.storage_profile,
        "tier"             : each.value.tier,
        "ansible_host"     : module.single_virtual_machine[each.key].ip_address
      })
      groups = [aap_group.vm_groups[each.value.security_profile].id]
    }

#### Job Execution

Triggers an AAP job template targeting the newly created inventory.

    resource "aap_job" "vm_demo_job" {
      job_template_id = var.job_template_id
      inventory_id    = aap_inventory.vm_inventory.id
      extra_vars      = jsonencode({})
      triggers        = local.vm_names
    }

