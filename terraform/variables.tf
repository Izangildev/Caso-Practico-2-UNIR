variable "location" {
  description = "Region de azure donde se crearan los recursos"
  type = string
  default = "westeurope"
}

variable "resource_group_name" {
    description = "Nombre del RG"
    type = string
    default = "rg-casopractico2-izan"
}

variable "tags" {
    description = "Tags comunes que se aplican a todos los recursos"
    type = map(string)
    default = {
      "enviroment" = "casopractico2"
    }
}