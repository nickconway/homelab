variable pm_api_host {
    type = string
    default = "https://pve.example.com"
}

variable pm_user {
    type = string
    default = "user@realm"
}

variable pm_api_token_id {
    type = string
    default = "talos-token"
}

variable pm_api_token_secret {
    type = string
    default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable pm_talos_iso_id {
    type = string
    default = "storage:iso/talos-x.x.x.iso"
}

variable talos_cp_id {
    type = number
    default = 1000
}

variable talos_worker_id {
    type = number
    default = 1050
}
