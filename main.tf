terraform {
  required_providers {
    thunder = {
      source  = "a10networks/thunder"
      version = "0.4.14"
    }
  }
  required_version = "~> 0.13"
}

############################
#service group provisioning
############################
resource "thunder_service_group" "service-group" {
  for_each = local.grouped
  name     = each.key
  protocol = var.slb_service_group_protocol

  dynamic "member_list" {
    for_each = each.value

    content {
      name = member_list.value.address
      port = member_list.value.port
      host = member_list.value.address
    }

  }
}

############################
#vip provisioning
############################
resource "thunder_virtual_server" "virtual-server" {
  for_each   = local.grouped_vip
  name       = each.value.vserver-name
  ip_address = each.value.vip
  port_list {
    port_number   = each.value.vport
    protocol      = each.value.vprotocol
    service_group = each.key
  }
}

locals {
  service_ids = transpose({
    for id, s in var.services : id => [s.name] if s.status == "passing"
  })
  grouped = {
    for name, ids in local.service_ids : name => [for id in ids : var.services[id]]
  }
  grouped_vip = {
    #vip, vport, vprotocol, vserver-name are mandatory
    for name, ids in local.service_ids : name => var.services[ids[0]].cts_user_defined_meta if lookup(var.services[ids[0]].cts_user_defined_meta, "vip", null) != null
  }
}
