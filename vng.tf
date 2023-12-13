# Create GatewaySubnet for VNG
resource "azurerm_subnet" "gw_subnet" {
  name                 = "GatewaySubnet"
  virtual_network_name = var.vng_vnet_name
  resource_group_name  = var.vng_rg_name
  address_prefixes = [var.vng_subnet_cidr]
}

# Obtain Public IP for VNG
resource "azurerm_public_ip" "vng_pip" {
  name                = "${var.vng_name}-pip"
  location            = var.vng_vnet_region
  resource_group_name = var.vng_rg_name

  allocation_method = "Static"
  sku = "Standard"
  zones = var.vng_pip_az_zones
}

# Obtain HA Public IP for VNG
resource "azurerm_public_ip" "vng_pip_ha" {
  name                = "${var.vng_name}-pip-ha"
  location            = var.vng_vnet_region
  resource_group_name = var.vng_rg_name

  allocation_method = "Static"
  sku = "Standard"
  zones = var.vng_pip_az_zones
}

# Create VNG
resource "azurerm_virtual_network_gateway" "vng" {
  name = var.vng_name
  location            = var.vng_vnet_region
  resource_group_name = var.vng_rg_name

  type = "Vpn"
  vpn_type = "RouteBased"

  active_active = true
  enable_bgp = true
  sku = "VpnGw2AZ"

  ip_configuration {
    name = "default"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vng_pip.id
    subnet_id = azurerm_subnet.gw_subnet.id
  }

  ip_configuration {
    name = "activeActive"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vng_pip_ha.id
    subnet_id = azurerm_subnet.gw_subnet.id
  }
}

resource "azurerm_local_network_gateway" "csr" {
  name                = "CSR"
  location            = var.vng_vnet_region
  resource_group_name = var.vng_rg_name

  gateway_address     = azurerm_public_ip.csr_pip.ip_address
  address_space       = ["${azurerm_network_interface.csr_eth0.private_ip_address}/32"]

  bgp_settings {
    asn = var.csr_asn
    bgp_peering_address = azurerm_network_interface.csr_eth0.private_ip_address
    peer_weight = 0
  }
}


resource "azurerm_virtual_network_gateway_connection" "to_csr" {
  name                = "to-csr"
  location            = var.vng_vnet_region
  resource_group_name = var.vng_rg_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vng.id
  local_network_gateway_id   = azurerm_local_network_gateway.csr.id

  shared_key = var.ipsec_psk
  enable_bgp = true
  connection_mode = "ResponderOnly"
}
