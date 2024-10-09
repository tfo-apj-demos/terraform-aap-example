module "single-virtual-machine" {
  source  = "app.terraform.io/tfo-apj-demos/single-virtual-machine/vsphere"
  version = "~> 1"

  ad_domain        = "example.com"
  backup_policy    = "daily"
  environment      = "dev"
  os_type          = "linux"
  security_profile = "web-server"
  site             = "sydney"
  size             = "medium"
  storage_profile  = "standard"
  tier             = "gold"
}

resource "aap_job" "sample_abc" {
  job_template_id = 7
}