variable "name" {
  type = string
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "image_repository" {
  type    = string
  default = "gcr.io/kuar-demo/kuard-amd64"
}

variable "image_tag" {
  type    = string
  default = "v0.9-green"
}

variable "config_envs" {
  type    = map(string)
  default = {}
}

variable "secret_config_envs" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "config_files" {
  type    = map(string)
  default = {}
}

variable "secret_config_files" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "min_http_server_replicas" {
  type    = number
  default = 1
}

variable "max_http_server_replicas" {
  type    = number
  default = 1
}
