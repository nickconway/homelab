variable pm_api_url {
    type = string
    default = "https://pve.example.com/api2/json"
}

variable pm_user {
    type = string
    default = "user@realm"
}

variable pm_api_token_id {
    type = string
    default = "user@realm!token_id"
}

variable pm_api_token_secret {
    type = string
    default = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable talos_cp_id {
    type = number
    default = 1000
}

variable talos_worker_id {
    type = number
    default = 1050
}
