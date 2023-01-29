provider "virtualbox" {
  # Configuration options
}

resource "virtualbox_vm" "master_node" {
  count     = 1
  name      = format("master_node-%02d", count.index + 1)
  image     = var.vm_image
  cpus      = 4
  memory    = "4096 mib"
  //user_data = file("${path.module}/user_data")

  network_adapter {
    type           = "bridged"
    host_interface = "wlp9s0"
  }

  provisioner "file" {
    source = "scripts/master_startup.sh"
    destination = "/tmp/master_startup.sh"

    connection {
      type = "ssh"
      user = "vagrant"
      private_key = file("${path.module}/.ssh/vagrant")
      timeout = "2m"
      host = virtualbox_vm.master_node.0.network_adapter.0.ipv4_address
    }
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/master_startup.sh",
        "/tmp/master_startup.sh",
    ]
    
    connection {
      type     = "ssh"
      user     = "vagrant"
      private_key = file("${path.module}/.ssh/vagrant")
      timeout = "2m"
      host = virtualbox_vm.master_node.0.network_adapter.0.ipv4_address
    }
  }
}

output "MasterIPAddr" {
  value = virtualbox_vm.master_node.*.network_adapter.0.ipv4_address
}

resource "virtualbox_vm" "worker_node" {
  count     = 2
  name      = format("worker_node-%02d", count.index + 1)
  image     = var.vm_image
  cpus      = 2
  memory    = "2048 mib"
  //user_data = file("${path.module}/user_data")

  network_adapter {
    type           = "bridged"
    host_interface = "wlp9s0"
  }
}

output "WorkerIPAddr_1" {
  value = element(virtualbox_vm.worker_node.*.network_adapter.0.ipv4_address, 1)
}

output "WorkerIPAddr_2" {
  value = element(virtualbox_vm.worker_node.*.network_adapter.0.ipv4_address, 2)
}
