resource "oci_file_storage_mount_target" "my_mount_target_1" {
  #Required
  availability_domain = "TGjA:PHX-AD-3"
  compartment_id      = "${var.compartment_ocid}"
  subnet_id           = "${oci_core_subnet.public01.id}"

  #Optional
  display_name = "${var.mount_target_1_display_name}"
}

resource "oci_file_storage_export_set" "my_export_set_1" {
  # Required
  mount_target_id = "${oci_file_storage_mount_target.my_mount_target_1.id}"

  # Optional
  display_name      = "my_export_set_1"
}

resource "oci_file_storage_export" "my_export_fs1_mt1" {
  #Required
  export_set_id  = "${oci_file_storage_export_set.my_export_set_1.id}"
  file_system_id = "${oci_file_storage_file_system.my_fs_1.id}"
  path           = "${var.export_path_fs1_mt1}"
}

resource "oci_file_storage_file_system" "my_fs_1" {
  #Required
  availability_domain = "TGjA:PHX-AD-3"
  compartment_id      = "${var.compartment_ocid}"

  #Optional
  display_name = "${var.file_system_1_display_name}"
}
