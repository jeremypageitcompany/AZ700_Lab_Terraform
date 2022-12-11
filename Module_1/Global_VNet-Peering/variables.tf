variable "project" {
  default     = "az700lab2peering-"
  description = "project name"
}

variable "environment" {
  default = "lab-"
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    org         = "jpitc.ca",
    environment = "terraform"
  }
}

variable "location" {
  default     = "canadacentral"
  description = "Location of the resource group."
}

variable "resource_group_location_2" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "subnet_vnet-001" {
  default     = ["10.10.0.0/16"]
  description = "address space of vnet1"
}

variable "subnet_vnet-002" {
  default     = ["10.20.0.0/16"]
  description = "address space of vnet2"
}

variable "subnet001-vnet001" {
  default     = ["10.10.0.0/24"]
  description = "subnet vnet1"
}

variable "subnet001-vnet002" {
  default     = ["10.20.0.0/24"]
  description = "subnet vnet2"
}

variable "vm_username" {
  description = "vm username"
  type        = string
  sensitive   = true
}

variable "vm_password" {
  description = "vm password"
  type        = string
  sensitive   = true
}