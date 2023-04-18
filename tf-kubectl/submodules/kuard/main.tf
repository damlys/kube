resource "kubectl_manifest" "config_envs_config_map" {
  yaml_body = yamlencode({
    apiVersion = "v1"
    kind       = "ConfigMap"
    metadata = {
      name      = "${var.name}-config-envs"
      namespace = var.namespace
      labels    = local.metadata_labels
    }
    data = var.config_envs
  })
}

resource "kubectl_manifest" "config_envs_secret" {
  yaml_body = yamlencode({
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "${var.name}-config-envs"
      namespace = var.namespace
      labels    = local.metadata_labels
    }
    stringData = var.secret_config_envs
  })

  sensitive_fields = [
    "data",
    "stringData",
  ]
}

resource "kubectl_manifest" "config_files_config_map" {
  yaml_body = yamlencode({
    apiVersion = "v1"
    kind       = "ConfigMap"
    metadata = {
      name      = "${var.name}-config-files"
      namespace = var.namespace
      labels    = local.metadata_labels
    }
    data = var.config_files
  })
}

resource "kubectl_manifest" "config_files_secret" {
  yaml_body = yamlencode({
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "${var.name}-config-files"
      namespace = var.namespace
      labels    = local.metadata_labels
    }
    stringData = var.secret_config_files
  })

  sensitive_fields = [
    "data",
    "stringData",
  ]
}

resource "kubectl_manifest" "general_service_account" {
  yaml_body = yamlencode({
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = {
      name      = "${var.name}-general"
      namespace = var.namespace
      labels = merge(local.metadata_labels, {
        "app.kubernetes.io/component" = "general"
      })
    }
  })
}

resource "kubectl_manifest" "http_server_deployment" {
  yaml_body = yamlencode({
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "${var.name}-http-server"
      namespace = var.namespace
      labels = merge(local.metadata_labels, {
        "app.kubernetes.io/component" = "http-server"
      })
    }
    spec = {
      replicas = var.min_http_server_replicas
      strategy = {
        type = "RollingUpdate"
      }
      selector = {
        matchLabels = merge(local.selector_labels, {
          "app.kubernetes.io/component" = "http-server"
        })
      }
      template = {
        metadata = {
          labels = merge(local.metadata_labels, {
            "app.kubernetes.io/component" = "http-server"
          })
          annotations = {
            "checksum/configs" = local.configs_checksum
          }
        }
        spec = {
          serviceAccountName = kubectl_manifest.general_service_account.name
          containers = [
            {
              name  = "http-server"
              image = "${var.image_name}:${var.image_tag}"
              envFrom = [
                {
                  configMapRef = {
                    name = kubectl_manifest.config_envs_config_map.name
                  }
                },
                {
                  secretRef = {
                    name = kubectl_manifest.config_envs_secret.name
                  }
                },
              ]
              volumeMounts = [
                {
                  name      = "config-files"
                  mountPath = "/run/secrets/kuard"
                  readOnly  = true
                },
              ]
              ports = [
                {
                  name          = "http"
                  containerPort = 8080
                  protocol      = "TCP"
                },
              ]
              readinessProbe = {
                httpGet = {
                  port = "http"
                  path = "/ready"
                }
              }
              livenessProbe = {
                httpGet = {
                  port = "http"
                  path = "/healthy"
                }
              }
              resources = {
                requests = {
                  cpu    = "1m"
                  memory = "1M"
                }
                limits = {
                  cpu    = "250m"
                  memory = "256M"
                }
              }
            },
          ]
          volumes = [
            {
              name = "config-files"
              projected = {
                sources = [
                  {
                    configMap = {
                      name = kubectl_manifest.config_files_config_map.name
                    }
                  },
                  {
                    secret = {
                      name = kubectl_manifest.config_files_secret.name
                    }
                  },
                ]
              }
            },
          ]
        }
      }
    }
  })
}

resource "kubectl_manifest" "http_server_horizontal_pod_autoscaler" {
  yaml_body = yamlencode({
    apiVersion = "autoscaling/v1"
    kind       = "HorizontalPodAutoscaler"
    metadata = {
      name      = "${var.name}-http-server"
      namespace = var.namespace
      labels = merge(local.metadata_labels, {
        "app.kubernetes.io/component" = "http-server"
      })
    }
    spec = {
      scaleTargetRef = {
        apiVersion = "apps/v1"
        kind       = "Deployment"
        name       = kubectl_manifest.http_server_deployment.name
      }
      minReplicas = var.min_http_server_replicas
      maxReplicas = var.max_http_server_replicas
    }
  })
}

resource "kubectl_manifest" "http_server_service" {
  yaml_body = yamlencode({
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      name      = "${var.name}-http-server"
      namespace = var.namespace
      labels = merge(local.metadata_labels, {
        "app.kubernetes.io/component" = "http-server"
      })
    }
    spec = {
      type     = "ClusterIP"
      selector = yamldecode(kubectl_manifest.http_server_deployment.yaml_body_parsed).spec.selector.matchLabels
      ports = [
        {
          name       = "http"
          port       = 8080
          protocol   = "TCP"
          targetPort = "http"
        },
      ]
    }
  })
}
