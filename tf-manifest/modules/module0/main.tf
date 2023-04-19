resource "kubernetes_manifest" "playground_tf_manifest_namespace" {
  manifest = {
    apiVersion = "v1"
    kind       = "Namespace"
    metadata = {
      name = "playground-tf-manifest"
    }
  }
}

module "kuard_test" {
  source = "../../submodules/kuard"

  name      = "kuard-test"
  namespace = kubernetes_manifest.playground_tf_manifest_namespace.object.metadata.name

  config_envs = {
    CONFIG_A = "test CONFIG_A"
    CONFIG_B = "test CONFIG_B"
  }
  secret_config_envs = {
    SECRET_A = "test SECRET_A"
    SECRET_B = "test SECRET_B"
  }
  config_files = {
    "config.json" = file("${path.module}/assets/kuard_test/config.json")
  }
  secret_config_files = {
    "secret.json" = file("${path.module}/assets/kuard_test/secret.json")
  }
}

module "kuard_prod" {
  source = "../../submodules/kuard"

  name      = "kuard-prod"
  namespace = kubernetes_manifest.playground_tf_manifest_namespace.object.metadata.name

  config_envs = {
    CONFIG_A = "prod CONFIG_A"
    CONFIG_B = "prod CONFIG_B"
  }
  secret_config_envs = {
    SECRET_A = "prod SECRET_A"
    SECRET_B = "prod SECRET_B"
  }
  config_files = {
    "config.json" = file("${path.module}/assets/kuard_prod/config.json")
  }
  secret_config_files = {
    "secret.json" = file("${path.module}/assets/kuard_prod/secret.json")
  }

  max_http_server_replicas = 2
}
