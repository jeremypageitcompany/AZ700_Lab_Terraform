variable "project" {
  default     = "az700lab1dns-"
  description = "project name"
}

variable "location" {
  default     = "canadacentral"
  description = "Location of the resource group."
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

variable "subnet_vnet-001" {
  default = "10.10.0.0/16"
}

variable "domain_name" {
  default = "jayhomelab.com"
}

variable "subnet001-vnet001" {
  default = "10.10.0.0/24"
}
variable "subnet002-vnet001" {
  default = "10.10.1.0/24"
}
variable "subnet003-vnet001" {
  default = "10.10.2.0/24"
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

