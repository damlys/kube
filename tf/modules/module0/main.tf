resource "kubernetes_namespace" "playground_tf" {
  metadata {
    name = "playground-tf"
  }
}

module "kuard_test" {
  source = "../../submodules/kuard"

  name      = "kuard-test"
  namespace = kubernetes_namespace.playground_tf.metadata.0.name

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
  namespace = kubernetes_namespace.playground_tf.metadata.0.name

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
