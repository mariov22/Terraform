# External network declaration
data "openstack_networking_network_v2" "extnet" {
  name = "ExtNet"
}

# Router creation
resource "openstack_networking_router_v2" "R1" {
  name                = "R1"
  external_network_id = data.openstack_networking_network_v2.extnet.id
}

resource "openstack_networking_router_v2" "R2" {
  name                = "R2"
  external_network_id = data.openstack_networking_network_v2.extnet.id
}

# Net 1 creation
resource "openstack_networking_network_v2" "Net_1" {
  name           = "Net_1"
  admin_state_up =  true
}

resource "openstack_networking_subnet_v2" "Subnet_1" {
  name        = "Subnet_1"
  network_id  = openstack_networking_network_v2.Net_1.id
  cidr        = "10.1.1.0/24"
  gateway_ip  = "10.1.1.1"
  ip_version  = 4
  dns_nameservers = ["8.8.8.8"]
}

# Net 2 creation
resource "openstack_networking_network_v2" "Net_2" {
  name           = var.Net_2
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "Subnet_2" {
  name        = "Subnet_2"
  network_id  = openstack_networking_network_v2.Net_2.id
  cidr        = "10.1.2.0/24"
  ip_version  = 4
}

# Net 3 creation
resource "openstack_networking_network_v2" "Net_3" {
  name           = "Net_3"
  admin_state_up =  true
}

resource "openstack_networking_subnet_v2" "Subnet_3" {
  name        = "Subnet_3"
  network_id  = openstack_networking_network_v2.Net_3.id
  cidr        = "10.1.3.0/24"
  gateway_ip  = "10.1.3.1"
  ip_version  = 4
  dns_nameservers = ["8.8.8.8"]
}

resource "openstack_networking_port_v2" "myport" {
  name           = "myport"
  network_id     = openstack_networking_network_v2.Net_1.id
  fixed_ip {
    subnet_id    = openstack_networking_subnet_v2.Subnet_1.id
    ip_address   = "10.1.1.1"
    }
}

# Router interface configuration
resource "openstack_networking_router_interface_v2" "R1-Net_1" {
  router_id = openstack_networking_router_v2.R1.id
  port_id = openstack_networking_port_v2.myport.id
  
}

resource "openstack_networking_port_v2" "dbport" {
  name           = "dbport"
  network_id     = openstack_networking_network_v2.Net_3.id
  fixed_ip {
    subnet_id    = openstack_networking_subnet_v2.Subnet_3.id
    ip_address   = "10.1.3.1"
    }
}

# Router interface configuration
resource "openstack_networking_router_interface_v2" "R2-Net_3" {
  router_id = openstack_networking_router_v2.R2.id
  port_id = openstack_networking_port_v2.dbport.id
  
}
