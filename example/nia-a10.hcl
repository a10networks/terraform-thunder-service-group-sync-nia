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

provider "thunder" {
  address  = "54.166.184.68"
  username = "admin"
  password = "a10"
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
