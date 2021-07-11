variable "vm_workers_size" {
  type = string
  description = "Tamaño de la máquina virtual worker"
  default = "Standard_D1_v2" # 3.5 GB, 1 vCore
}

variable "vm_nfs_size" {
  type = string
  description = "Tamaño de la máquina virtual nfc"
  default = "Standard_D1_v2" # 3.5 GB, 1 vCore
}

variable "vm_masters_size" {
  type = string
  description = "Tamaño de la máquina virtual master"
  default = "Standard_D2d_v4" # 8 GB, 2 vCore
}

variable "masters" {
  type = list(string)
  description = "Lista de vms master"
  default = ["master1.acme.es"]
}

variable "nfs"{
  type = list(string)
  description = "Lista de vms nfc"
  default = ["nfs1.acme.es"]
}

variable "workers"{
  type = list(string)
  description = "Lista de vms workers"
  default = ["worker01.acme.es","worker02.acme.es"]
}
