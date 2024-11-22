resource "openstack_compute_instance_v2" "admin" {
  name        = "admin"
  flavor_name = var.flavor_server    
  image_name  = var.server_image     
  #key_pair    = var.keypair_name
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]

  network {
    uuid = openstack_networking_network_v2.Net_1.id
  }

  network {
    uuid = openstack_networking_network_v2.Net_2.id
  }

  user_data = <<-EOT
    #cloud-config
    runcmd:
      - sed -i 's/^#Port 22/Port 2020/' /etc/ssh/sshd_config
      - systemctl restart sshd
  EOT
  }

resource "openstack_networking_floatingip_v2" "admin-fip" {
  pool = data.openstack_networking_network_v2.extnet.name
}



resource "openstack_compute_floatingip_associate_v2" "admin-fip-assoc" {
  floating_ip = openstack_networking_floatingip_v2.admin-fip.address
  instance_id = openstack_compute_instance_v2.admin.id
}

