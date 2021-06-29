log_level = "INFO"
consul {
  address = "34.73.82.31:8500"
}

buffer_period {
  min = "5s"
  max = "20s"
}

service {
  name       = "web"
  datacenter = "us-east1"
}

driver "terraform" {
  log = true
  required_providers {
    thunder = {
      source = "a10networks/thunder"
      version = "0.4.7"
    }
  }
}

#Optional Service metadata block(s) to configure vip block
service {
  name = "web"
  cts_user_defined_meta = {
      vserver-name = "vs-web",
      vport = 80,
      vprotocol = "tcp"
      vip = "10.10.10.10"
  }
}

service {
  name = "db"
  cts_user_defined_meta = {
      vserver-name = "vs-db",
      vport = 90,
      vprotocol = "tcp"
      vip = "10.10.10.20"
  }
}


provider "thunder" {
  address  = "54.166.184.68"
  username = "*****"
  password = "***"
}

task {
  name        = "demo-test"
  description = "automate services for website-x"
  source      = "terraform-thunder-consul-sync-nia"
  #version    = "v0.1.0"
  providers   = ["thunder"]
  services    = ["web","db"]
  variable_files = "terraform-thunder-consul-sync-nia/example/terraform.tfvars"
}
