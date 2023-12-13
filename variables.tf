variable "vng_rg_name" {
  description = "Provide existing Resource Group Name for VNG vNet"
}

variable "vng_vnet_region" {
  description = "Provide region for VNG vNet region"
}

variable "vng_vnet_name" {
  description = "Provide Virtual Network name for the VNG to be deployed to"
}

variable "vng_subnet_cidr" {
  description = "Provide VNG GatewaySubnet CIDR, need to be at least /27, it also need to be free in current vNet address space"
}

variable "vng_name" {
  description = "Provide VNG Name"
  default = "vng"
}

variable "vng_pip_az_zones" {
  description = "Provide list of availability zones for VNG Public IP"
  type        = list(any)
  default = [ 1,2,3 ]
}

variable "local_network_gateway_name" {
  description = "Provide Loca Network Gateway Name"
  default = "csr2vng"
}

variable "csr_rg_name" {
  description = "Provide CSR resource group name"
  default = "testcsr"
}

variable "csr_rg_location" {
    description = "Provide location of CSR resource group"
    default = "West Europe"
}

variable "csr_name" {
    description = "Provide CSR Name"
    default = "csr-onprem"
}

variable "csr_vnet_address_space" {
  description = "Provide CSR vNet address space"
  default = "10.0.32.0/24"
}

variable "csr_public_subnet_address_space" {
  description = "Provide CSR vNet address space"
  default = "10.0.32.0/25"
}

variable "csr_private_subnet_address_space" {
  description = "Provide CSR vNet address space"
  default = "10.0.32.128/25"
}

variable "csr_asn" {
  description = "CSR ASN number, cannot be 65515"
  default = 65100
}

variable "admin_username" {
  description = "Provide CSR admin user name"
  default = "azureuser"
}

variable "admin_password" {
  description = "Provide CSR admin password"
  default = "Aviatrix123#"
}

variable "ipsec_psk" {
  description = "Provide IPSec Pre-shared key"
  default = "Aviatrix123#"
}

variable "public_key_file" {
  description = "Provide test VM public key location"
  default = ""
}