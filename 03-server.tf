
resource "openstack_compute_instance_v2" "server" {
  for_each = var.server_names
  name        = each.key
  flavor_name = var.flavor_server    
  image_name  = var.server_image 
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]    

  network {
    port = openstack_networking_port_v2.server[each.key]-net1.id
  }

  network {
    port = openstack_networking_port_v2.server[each.key]-net2.id
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
          <head><title>Welcome to Terraform Web Server</title></head>
          <body>
            <h1>Terraform Web Server - Nginx Web Server</h1>
            <p>Deployed using Terraform and cloud-init.</p>
          </body>
          </html>

    runcmd:
      - systemctl start nginx
      - systemctl enable nginx
        
  EOT
}

