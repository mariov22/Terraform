resource "openstack_compute_instance_v2" "db" {
  name        = "db"
  flavor_name = var.flavor_db   
  image_name  = var.server_image     
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]

  network {
    port = openstack_networking_port_v2.db-net2.id
  }
  network {
    port = openstack_networking_port_v2.db-net3.id
  }
  user_data = <<-EOT
    #cloud-config
    runcmd:
      - apt-get update
      - apt-get install -y mysql-server
      - systemctl start mysql
      - systemctl enable mysql
  EOT
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

resource "openstack_networking_port_v2" "db-net3" {
  name           = "port-db-net3"
  network_id     = openstack_networking_network_v2.Net_3.id
  admin_state_up = true
  security_group_ids = [openstack_networking_secgroup_v2.my_security_group.id]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.Subnet_3.id
  }
}