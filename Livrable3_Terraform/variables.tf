variable "resource_group_name" {
  description = "Existing resource group name"
  type        = string
  default     = "ozoux-rg"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "cloudshield"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "hub_vnet_cidr" {
  description = "CIDR for Hub VNet"
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "prod_vnet_cidr" {
  description = "CIDR for Prod Spoke VNet"
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "hub_firewall_subnet_cidr" {
  description = "CIDR for Azure Firewall subnet"
  type        = list(string)
  default     = ["10.10.1.0/26"]
}

variable "hub_gateway_subnet_cidr" {
  description = "CIDR for VPN Gateway subnet"
  type        = list(string)
  default     = ["10.10.2.0/27"]
}

variable "hub_bastion_subnet_cidr" {
  description = "CIDR for Azure Bastion subnet"
  type        = list(string)
  default     = ["10.10.3.0/26"]
}

variable "hub_shared_services_subnet_cidr" {
  description = "CIDR for shared services subnet"
  type        = list(string)
  default     = ["10.10.4.0/24"]
}

variable "prod_web_subnet_cidr" {
  description = "CIDR for web subnet"
  type        = list(string)
  default     = ["10.20.1.0/24"]
}

variable "prod_app_subnet_cidr" {
  description = "CIDR for app subnet"
  type        = list(string)
  default     = ["10.20.2.0/24"]
}

variable "prod_db_subnet_cidr" {
  description = "CIDR for db subnet"
  type        = list(string)
  default     = ["10.20.3.0/24"]
}

variable "prod_private_endpoints_subnet_cidr" {
  description = "CIDR for private endpoints subnet"
  type        = list(string)
  default     = ["10.20.4.0/24"]
}

variable "admin_username" {
  description = "Admin username for Linux VMs"
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_public_key" {
  description = "SSH public key content"
  type        = string
}

variable "vm_size" {
  description = "Size for demo VMs"
  type        = string
  default     = "Standard_B1s"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    course      = "reseau"
    student     = "Guillaume.OZOUX"
    project     = "cloudshield"
    environment = "prod"
  }
}
