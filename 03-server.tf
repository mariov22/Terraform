
resource "openstack_compute_instance_v2" "server" {
  for_each = var.server_names
  name        = each.key
  flavor_name = var.flavor_server    
  image_name  = var.server_image 
  security_groups = [openstack_networking_secgroup_v2.my_security_group.name]    

  network {
    uuid = openstack_networking_network_v2.Net_1.id
  }

   network {
    uuid = openstack_networking_network_v2.Net_2.id
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
            <h1>Terraform Web Server - Nginx Web Server </h1>
            <h2>${each.key} is giving you this service </h2>
            <p>Deployed using Terraform and cloud-init.</p>
          </body>
          </html>

    runcmd:
      - apt-get update
      - systemctl start nginx
      - systemctl enable nginx
        
  EOT
}

