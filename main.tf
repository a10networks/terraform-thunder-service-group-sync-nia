terraform {
  required_providers {
    thunder = {
      source = "a10networks/thunder"
      version = "0.4.14"
    }
  }
  required_version = "~> 0.13"
}

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

locals {
  service_ids = transpose({
      for id, s in var.services : id => [s.name] if s.status == "passing"
  })
  grouped = {
    for name, ids in local.service_ids : name => [for id in ids : var.services[id]]
  }
}
