terraform {
  required_providers {
    thunder = {
      source = "a10networks/thunder"
      version = "0.4.7"
    }
  }
  required_version = "~>0.13.0"
}


terraform_provider "thunder" {
  address  = var.thunder_host
  username = var.thunder_user
  password = var.thunder_passd
}

module "thunder_module" {
  source   = "../"
  services = var.services
  protocol = var.slb_service_group_protocol
}
