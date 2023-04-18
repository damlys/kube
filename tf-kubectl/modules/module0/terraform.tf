terraform {
  required_version = ">= 1.3.3, < 2.0.0"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0, < 2.0.0"
    }
  }

  backend "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = "docker-desktop"
    namespace      = "default"
    secret_suffix  = "module0-kubectl"
  }
}

provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}
