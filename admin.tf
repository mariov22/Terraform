resource "openstack_compute_instance_v2" "admin" {
  name        = "admin"
  flavor_name = var.flavor_server    
  image_name  = var.server_image     
#   key_pair    = var.keypair_name     

  network {
    # port = openstack_networking_port_v2.admin-net1.id
    uuid = openstack_networking_network_v2.Net_1.id
  }

  network {
    # port = openstack_networking_port_v2.admin-net2.id
    uuid = openstack_networking_network_v2.Net_1.id
  }

  user_data = <<-EOT
    #cloud-config
    runcmd:
      - systemctl start sshd
  EOT
  }

# resource "openstack_networking_port_v2" "admin-net1" {
#   name           = "port-admin-net1"
#   network_id     = openstack_networking_network_v2.Net_1.id
#   admin_state_up = true
#   security_group_ids = [openstack_networking_secgroup_v2.my_security_group.id]
#   fixed_ip {
#     subnet_id = openstack_networking_subnet_v2.Subnet_1.id
#   }
# }

# resource "openstack_networking_port_v2" "admin-net2" {
#   name           = "port-admin-net2"
#   network_id     = openstack_networking_network_v2.Net_2.id
#   admin_state_up = true
#   security_group_ids = [openstack_networking_secgroup_v2.my_security_group.id]
#   fixed_ip {
#     subnet_id = openstack_networking_subnet_v2.Subnet_2.id
#   }
# }

resource "openstack_networking_floatingip_v2" "admin-fip" {
  pool = data.openstack_networking_network_v2.extnet.name
}



resource "openstack_compute_floatingip_associate_v2" "admin-fip-assoc" {
  floating_ip = openstack_networking_floatingip_v2.admin-fip.address
  instance_id = openstack_compute_instance_v2.admin.id
}

