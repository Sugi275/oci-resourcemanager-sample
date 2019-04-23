resource "oci_core_virtual_network" "tfvcn" {
  cidr_block = "10.0.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  display_name = "tfvcn"
  dns_label = "tfvcn"
}

resource "oci_core_internet_gateway" "tf-ig1" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "tf-ig1"
  vcn_id         = "${oci_core_virtual_network.tfvcn.id}"
}

resource "oci_core_default_route_table" "tf-default-route-table" {
  manage_default_resource_id = "${oci_core_virtual_network.tfvcn.default_route_table_id}"
  display_name               = "tf-default-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.tf-ig1.id}"
  }
}

resource "oci_core_security_list" "TFSecurityList" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.tfvcn.id}"
  display_name   = "TFSecurityList"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow outbound udp traffic on a port range
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "17"        // udp
    stateless   = true

    udp_options {
      // These values correspond to the destination port range.
      "min" = 319
      "max" = 320
    }
  }

  // allow inbound ssh traffic from a specific port
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      // These values correspond to the destination port range.
      "min" = 22
      "max" = 22
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = true

    icmp_options {
      "type" = 3
      "code" = 4
    }
  }
  
  // allow inbound nfs traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "10.0.0.0/16"
    stateless = false

    tcp_options {
      "min" = 111
      "max" = 111
    }
  }
  
  // allow inbound nfs traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "10.0.0.0/16"
    stateless = false

    tcp_options {
      "min" = 2048
      "max" = 2050
    }
  }
  
  // allow inbound nfs traffic
  ingress_security_rules {
    protocol  = "17"        // udp
    source    = "10.0.0.0/16"
    stateless = false

    udp_options {
      "min" = 111
      "max" = 111
    }
  }
  
  // allow inbound nfs traffic
  ingress_security_rules {
    protocol  = "17"        // udp
    source    = "10.0.0.0/16"
    stateless = false

    udp_options {
      "min" = 2048
      "max" = 2048
    }
  }
  
  // allow inbound nfs traffic
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "17"        // udp
    stateless   = true

    udp_options {
      // These values correspond to the destination port range.
      "min" = 111
      "max" = 111
    }
  }
}

resource "oci_core_subnet" "public01" {
  cidr_block = "10.0.1.0/24"
  display_name = "public01"
  dns_label = "public01"
  vcn_id = "${oci_core_virtual_network.tfvcn.id}"
  prohibit_public_ip_on_vnic = false
  security_list_ids = ["${oci_core_security_list.TFSecurityList.id}"]
  route_table_id = "${oci_core_virtual_network.tfvcn.default_route_table_id}"
  dhcp_options_id = "${oci_core_virtual_network.tfvcn.default_dhcp_options_id}"
  compartment_id = "${var.compartment_ocid}"
}

resource "oci_core_subnet" "private01" {
  cidr_block = "10.0.2.0/24"
  display_name = "private01"
  dns_label = "private01"
  vcn_id = "${oci_core_virtual_network.tfvcn.id}"
  prohibit_public_ip_on_vnic = true
  security_list_ids = ["${oci_core_virtual_network.tfvcn.default_security_list_id}"]
  route_table_id = "${oci_core_virtual_network.tfvcn.default_route_table_id}"
  dhcp_options_id = "${oci_core_virtual_network.tfvcn.default_dhcp_options_id}"
  compartment_id = "${var.compartment_ocid}"
}
