terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://pve.conway.dev/api2/json"
  pm_user             = "nick@authentik"
  pm_api_token_id     = "nick@authentik!opentofu"
  pm_api_token_secret = "1434f821-d015-4d36-bdb5-70e5dace7043"
}

resource "proxmox_vm_qemu" "talos-cp" {
  target_node = "pve"
  agent = 1
  skip_ipv6 = true
  count = 3
  name = "talos-cp-0${count.index}"
  vmid = "100${count.index}"

  memory = 4096

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
    tag = "10"
  }

  disks {
    virtio {
      virtio0 {
        disk {
          storage = "local-lvm"
          size = "16G"
        }
      }
    }

    ide {
      ide2 {
        cdrom {
          iso = "nas:iso/talos-1.9.2.iso"
        }
      }
    }
  }
}

resource "proxmox_vm_qemu" "talos-worker" {
  target_node = "pve"
  agent = 1
  count = 3
  name = "talos-worker-0${count.index}"
  vmid = "105${count.index}"

  memory = 2048

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
    tag = "10"
  }

  disks {
    virtio {
      virtio0 {
        disk {
          storage = "local-lvm"
          size = "16G"
        }
      }
    }

    ide {
      ide2 {
        cdrom {
          iso = "nas:iso/talos-1.9.2.iso"
        }
      }
    }
  }
}

output "cp-nodes" {
  value = [
    for instance, node in proxmox_vm_qemu.talos-cp: "${node.name} ${node.default_ipv4_address}"
  ]
}

output "worker-nodes" {
  value = [
    for instance, node in proxmox_vm_qemu.talos-worker: "${node.name} ${node.default_ipv4_address}"
  ]
}
