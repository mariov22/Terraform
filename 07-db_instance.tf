resource "openstack_compute_instance_v2" "db" {
  name        = "db"
  flavor_name = var.flavor_db   
  image_name  = var.server_image     
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]

  network {
    port = openstack_networking_port_v2.db-net2.id
  }
}

resource "openstack_networking_port_v2" "db-net2" {
  name           = "port-db-net2"
  network_id     = openstack_networking_network_v2.Net_2.id
  admin_state_up = true
  security_group_ids = [openstack_networking_secgroup_v2.my_security_group.id]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.Subnet_2.id
  }
}