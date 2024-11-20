resource "openstack_compute_instance_v2" "s2" {
  name        = "s2"
  flavor_name = var.flavor_server    
  image_name  = var.server_image     
#   key_pair    = var.keypair_name     

  network {
    port = openstack_networking_port_v2.server2-net1.id
  }

  network {
    port = openstack_networking_port_v2.server2-net2.id
  }

  user_data = file("${path.module}/server1_config.yaml")
}

resource "openstack_networking_port_v2" "server2-net1" {
  name           = "port-server2-net1"
  network_id     = openstack_networking_network_v2.Net_1.id
  admin_state_up = true
  security_group_ids = [openstack_networking_secgroup_v2.my_security_group.id]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.Subnet_1.id
  }
}

resource "openstack_networking_port_v2" "server2-net2" {
  name           = "port-server2-net2"
  network_id     = openstack_networking_network_v2.Net_2.id
  admin_state_up = true
  security_group_ids = [openstack_networking_secgroup_v2.my_security_group.id]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.Subnet_2.id
  }
}
