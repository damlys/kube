terraform {
  required_version = ">= 1.3.3, < 2.0.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.15.0, < 3.0.0"
    }
  }

  backend "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = "docker-desktop"
    namespace      = "default"
    secret_suffix  = "tf-manifest.modules.module0"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}
