output "openttd_server_id" {
  value = hcloud_server.openttd.id
}

output "openttd_server_ip" {
  value = hcloud_server.openttd.ipv4_address
}
