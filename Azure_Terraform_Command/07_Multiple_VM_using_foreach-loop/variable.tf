variable "vm" {

  type = map(object({

    vm_name  = string
    nic_name = string
    ip_name  = string

  }))

  default = {

    VM1 = {

      vm_name  = "webserver"
      nic_name = "webserver-nic"
      ip_name  = "webserver-ip"

    }

    VM2 = {

      vm_name  = "appserver"
      nic_name = "appserver-nic"
      ip_name  = "appserver-ip"

    }

    VM3 = {

      vm_name  = "dbserver"
      nic_name = "dbserver-nic"
      ip_name  = "dbserver-ip"

    }

  }

}

variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}