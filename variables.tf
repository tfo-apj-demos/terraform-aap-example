variable "TFC_WORKSPACE_ID" {}

variable "domain" {
  description = "The Active Directory domain for the VMs."
  type        = string
}

variable "job_template_id" {
  description = "The ID of the job template to run."
  type        = string
  default = "7"
}