resource "openstack_fw_rule_v2" "ssh_rule" {
    name                = "allow_ssh"
    action              = "allow"
    protocol            = "tcp"
    destination_port    = "2022"
    source_ip_address   = "0.0.0.0/0"
    destination_ip_address = openstack_compute_instance_v2.admin.network[0].fixed_ip_v4
    depends_on             = [openstack_compute_instance_v2.admin]
}

# resource "openstack_fw_rule_v2" "http_rule" {
#     name                ="allow_http"
#     action              = "allow"
#     protocol            = "tcp"
#     destination_port    = "80"
#     source_ip_address   = "0.0.0.0/0"
#     destination_ip_address = openstack_lb_loadbalancer_v2.http.vip_address
#     depends_on             = [openstack_lb_loadbalancer_v2.http]
# }


resource "openstack_fw_rule_v2" "allow_internal" {
    name                = "allow_internal"
    action              = "allow"
    protocol            = "any"
    source_ip_address   = "10.1.1.1"
    destination_ip_address = "0.0.0.0/0"
    depends_on             = [openstack_compute_subnet_v2.Subnet_1]
}


resource "openstack_fw_policy_v2" "policy_in" {
    name        = "firewall_policy_in"
    rules       = [openstack_fw_rule_v2.allow_ssh.id, openstack_fw_rule_v2.http_rule.id]
    depends_on  = [openstack_fw_rule_v2.allow_ssh, openstack_fw_rule_v2.http_rule]
}

resource "openstack_fw_policy_v2" "policy_out" {
    name        = "firewall_policy_out"
    rules       = [openstack_fw_rule_v2.allow_internal.id]
    depends_on  = [openstack_fw_rule_v2.allow_internal]
}

resource "openstack_fw_group_v2" "firewall_group" {
    name                = "firewall_group"
    ingress_firewall_policy_id = openstack_fw_policy_v2.policy_in.id
    egress_firewall_policy_id  = openstack_fw_policy_v2.policy_out.id
    ports                      = [openstack_networking_port_v2.R1-Net_1.port_id]
    depends_on                 = [openstack_fw_policy_v2.policy_in, openstack_fw_policy_v2.policy_out, openstack_networking_port_v2.R1-Net_1]
}