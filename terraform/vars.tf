variable "vm_size" {
  type = string
  description = "Tamaño de la máquina virtual"
  default = "Standard_D1_v2" # 3.5 GB, 1 vCore
}

variable "vm_masters_size" {
  type = string
  description = "Tamaño de la máquina virtual master"
  default = "Standard_A4_v2" # 8 GB, 4 vCore
}

variable "masters" {
  type = list(string)
  description = "vms master"
  default = ["Master01"]
}

variable "workers"{
  type = list(string)
  description = "vms workers"
  default = ["Worker01","Worker02"]
}
