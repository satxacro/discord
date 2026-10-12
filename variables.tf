variable "server_id" {
  description = "ID of the Discord server (guild) this repo manages. Written to server.auto.tfvars by the bootstrap."
  type        = string
  default     = "" # empty only until the bootstrap has run
}
