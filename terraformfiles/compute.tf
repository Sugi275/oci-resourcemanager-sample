resource "oci_core_instance" "web01" {
  count               = "1"
  availability_domain = "TGjA:PHX-AD-1"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "web01"
  shape               = "VM.Standard2.2"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.public01.id}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "web01"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid[var.region]}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
  timeouts {
    create = "60m"
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "15m"
      host        = "${oci_core_instance.web01.public_ip}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "sudo yum -y install nfs-utils > nfs-utils-install.log",
      "sudo mkdir -p /mnt/filestorage/fs1",
      "sudo mount ${local.mount_target_1_ip_address}:${var.export_path_fs1_mt1} /mnt/filestorage/fs1",
    ]
  }
}

resource "oci_core_instance" "web02" {
  count               = "1"
  availability_domain = "TGjA:PHX-AD-2"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "web02"
  shape               = "VM.Standard2.2"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.public01.id}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "web02"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid[var.region]}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
  }
  timeouts {
    create = "60m"
  }
  
  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "15m"
      host        = "${oci_core_instance.web02.public_ip}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "sudo yum -y install nfs-utils > nfs-utils-install.log",
      "sudo mkdir -p /mnt/filestorage/fs1",
      "sudo mount ${local.mount_target_1_ip_address}:${var.export_path_fs1_mt1} /mnt/filestorage/fs1",
    ]
  }
}
