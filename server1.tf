
resource "openstack_compute_instance_v2" "s1" {
  name        = "s1"
  flavor_name = var.flavor_server    
  image_name  = var.server_image 
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]    

  network {
    port = openstack_networking_port_v2.server1-net1.id
  }

  network {
    port = openstack_networking_port_v2.server1-net2.id
  }

  user_data = <<-EOT
    #cloud-config
    packages:
      - nginx

    write_files:
      - path: /var/www/html/index.html
        permissions: '0644'
        content: |
          <html>
          <head><title>Welcome to Server 1</title></head>
          <body>
            <h1>Server 1 - Nginx Web Server</h1>
            <p>Deployed using Terraform and cloud-init.</p>
          </body>
          </html>

    runcmd:
      - systemctl start nginx
      - systemctl enable nginx
        
  EOT
}



resource "openstack_networking_port_v2" "server1-net1" {
  name           = "port-server1-net1"
  network_id     = openstack_networking_network_v2.Net_1.id
  admin_state_up = true
  security_group_ids = [openstack_networking_secgroup_v2.my_security_group.id]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.Subnet_1.id
  }
}

resource "openstack_networking_port_v2" "server1-net2" {
  name           = "port-server1-net2"
  network_id     = openstack_networking_network_v2.Net_2.id
  admin_state_up = true
  security_group_ids = [openstack_networking_secgroup_v2.my_security_group.id]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.Subnet_2.id
  }
}
