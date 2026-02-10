terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "${var.pm_api_host}/api2/json"
  pm_user             = "${var.pm_user}"
  pm_api_token_id     = "${var.pm_user}!${var.pm_api_token_id}"
  pm_api_token_secret = "${var.pm_api_token_secret}"

  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}

resource "proxmox_vm_qemu" "talos-cp" {
  target_node = "pve"
  agent = 1
  skip_ipv6 = true
  count = 3
  name = "talos-cp-0${count.index}"
  vmid = "${var.talos_cp_id + count.index}"

  memory = 4096

  cpu {
    cores = 4
  }

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
    tag = "10"
    macaddr = "BC:24:11:00:46:E${count.index}"
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
          iso = "${var.pm_talos_iso_id}"
        }
      }
    }
  }

  startup_shutdown {
    order            = -1
    shutdown_timeout = -1
    startup_delay    = -1
  }
}

resource "proxmox_vm_qemu" "talos-worker" {
  target_node = "pve"
  agent = 1
  skip_ipv6 = true
  count = 3
  name = "talos-worker-0${count.index}"
  vmid = "${var.talos_worker_id + count.index}"

  memory = 2048

  cpu {
    cores = 2
  }

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
    tag = "10"
    macaddr = "BC:24:11:00:46:F${count.index}"
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
          iso = "${var.pm_talos_iso_id}"
        }
      }
    }
  }

  startup_shutdown {
    order            = -1
    shutdown_timeout = -1
    startup_delay    = -1
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
