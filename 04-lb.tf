resource "openstack_lb_loadbalancer_v2" "http" {
    name = "http_loadbalancer"
    vip_subnet_id = openstack_networking_subnet_v2.Subnet_1.id
    depends_on = [openstack_compute_instance_v2.server]
}

resource "openstack_lb_listener_v2" "http" {
    name = "http_listener"
    protocol = "HTTP"
    protocol_port = 80
    loadbalancer_id = openstack_lb_loadbalancer_v2.http.id
    depends_on = [openstack_lb_loadbalancer_v2.http]
}

resource "openstack_lb_pool_v2" "http" {
    name = "http_pool"
    protocol = "HTTP"
    lb_method = "ROUND_ROBIN"
    listener_id = openstack_lb_listener_v2.http.id
    depends_on = [openstack_lb_listener_v2.http]
}

resource "openstack_lb_member_v2" "http" {
    for_each = var.server_names
    address = openstack_compute_instance_v2.server[each.key].access_ip_v4
    protocol_port = 80
    pool_id = openstack_lb_pool_v2.http.id
    subnet_id = openstack_networking_subnet_v2.Subnet_1.id
    depends_on = [openstack_lb_pool_v2.http]
}

resource "openstack_networking_floatingip_v2" "lb-fip" {
  pool = data.openstack_networking_network_v2.extnet.name
}

resource "openstack_compute_floatingip_associate_v2" "lb-fip-assoc" {
  floating_ip = openstack_networking_floatingip_v2.lb-fip.address
  port_id = openstack_lb_loadbalancer_v2.http.vip_port_id
}