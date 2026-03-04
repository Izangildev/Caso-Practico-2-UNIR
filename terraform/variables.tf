variable "location" {
  description = "Region de azure donde se crearan los recursos"
  type        = string
  default     = "norwayeast"
}

variable "resource_group_name" {
  description = "Nombre del RG"
  type        = string
  default     = "rg-casopractico2-izan"
}

variable "tags" {
  description = "Tags comunes que se aplican a todos los recursos"
  type        = map(string)
  default = {
    "environment" = "casopractico2"
  }
}

variable "acr_name" {
  description = "ACR name (must be globally unique, lowercase, 5-50 chars)."
  type        = string
  default     = "acrcp2izan12345"
}

variable "acr_sku" {
  description = "ACR SKU"
  type        = string
  default     = "Basic"
}

variable "aks_name" {
  description = "AKS cluster name."
  type        = string
  default     = "aks-cp2"
}

variable "aks_dns_prefix" {
  description = "DNS prefix for AKS."
  type        = string
  default     = "akscp2"
}

variable "aks_node_count" {
  description = "Number of worker nodes."
  type        = number
  default     = 1
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes."
  type        = string
  default     = "Standard_B2s_v2"
}