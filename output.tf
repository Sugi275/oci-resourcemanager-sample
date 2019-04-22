output "InstancePublicIPs" {
  value = ["${oci_core_instance.web01.*.public_ip}",
           "${oci_core_instance.web02.*.public_ip}"]
}
