provider "hcloud" {
  token   = var.hetzner_token
  version = "~> 1.15"
}

resource "hcloud_ssh_key" "default" {
  name       = "Terraform-managed SSH key"
  public_key = file(var.ssh_public_key_path)
}

resource "hcloud_server" "openttd" {
  image = "debian-10"
  labels = {
    managed_by_terraform = true
  }
  location    = var.hetzner_location
  name        = "tf-openttd-debian"
  server_type = "cx11"
  ssh_keys    = ["${hcloud_ssh_key.default.id}"]

  provisioner "file" {
    connection {
      host        = self.ipv4_address
      private_key = file(var.ssh_private_key_path)
    }
    source      = "openttd.service"
    destination = "/etc/systemd/system/openttd.service"
  }

  provisioner "remote-exec" {
    connection {
      host        = self.ipv4_address
      private_key = file(var.ssh_private_key_path)
    }
    script = "provision-openttd.sh"
  }

  provisioner "file" {
    connection {
      host        = self.ipv4_address
      private_key = file(var.ssh_private_key_path)
    }
    source      = "openttd.cfg"
    destination = "/home/openttd/.openttd/openttd.cfg"
  }

  provisioner "remote-exec" {
    connection {
      host        = self.ipv4_address
      private_key = file(var.ssh_private_key_path)
    }
    inline = ["systemctl start openttd"]
  }

}
