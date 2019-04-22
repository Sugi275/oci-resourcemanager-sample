variable "region" {
    default = "us-phoenix-1"
}

variable "compartment_ocid" {
    default = "ocid1.compartment.oc1..aaaaaaaasaxgjviqpyubmkpj3pnh6khw4wtsc736bquokfqgduq6h7wubsta"
}

variable "instance_image_ocid" {
    type = "map"
    default = {
        // See https://docs.us-phoenix-1.oraclecloud.com/images/
        // Oracle-provided image "Oracle-Linux-7.6-2019.02.20-0"
        us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaapxvrtwbpgy3lchk2usn462ekarljwg4zou2acmundxlkzdty4bjq"
        us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaannaquxy7rrbrbngpaqp427mv426rlalgihxwdjrz3fr2iiaxah5a"
        eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa527xpybx2azyhcz2oyk6f4lsvokyujajo73zuxnnhcnp7p24pgva"
        uk-london-1 = "ocid1.image.oc1.uk-london-1.aaaaaaaarruepdlahln5fah4lvm7tsf4was3wdx75vfs6vljdke65imbqnhq"
        ca-toronto-1 = "ocid1.image.oc1.ca-toronto-1.aaaaaaaa7ac57wwwhputaufcbf633ojir6scqa4yv6iaqtn3u64wisqd3jjq"
    }
}

variable "mount_target_1_display_name" {
    default = "tf-mounttarget1"
}

variable "file_system_1_display_name" {
    default = "tf-fs1"
}

variable "export_path_fs1_mt1" {
    default = "/tf-fs1"
}

variable "ssh_public_key" {
    default = "overwrite by resourcemanager"
}

variable "ssh_private_key" {
    default = "overwrite by resourcemanager"
}

locals {
  mount_target_1_ip_address = "${lookup(data.oci_core_private_ips.ip_mount_target1.private_ips[0], "ip_address")}"
}

data "oci_core_private_ips" ip_mount_target1 {
  subnet_id = "${oci_file_storage_mount_target.my_mount_target_1.subnet_id}"

  filter {
    name   = "id"
    values = ["${oci_file_storage_mount_target.my_mount_target_1.private_ip_ids.0}"]
  }
}
