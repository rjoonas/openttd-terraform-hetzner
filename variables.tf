variable "hetzner_token" {
  description = "Hetzner Cloud API access token (Cloud console: Project -> API tokens)"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to a SSH public key that you want to use for managing the server"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to a SSH private key that you want to use for managing the server"
  type        = string
}

variable "hetzner_location" {
  description = "Hetzner data center to use – default is Helsinki, Finland"
  default     = "hel1"
  type        = string
}
