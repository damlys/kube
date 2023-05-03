resource "kubernetes_manifest" "config_envs_config_map" {
  manifest = {
    apiVersion = "v1"
    kind       = "ConfigMap"
    metadata = {
      name      = "${var.name}-config-envs"
      namespace = var.namespace
      labels    = local.metadata_labels
    }
    data = var.config_envs
  }
}

resource "kubernetes_manifest" "config_envs_secret" {
  manifest = {
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "${var.name}-config-envs"
      namespace = var.namespace
      labels    = local.metadata_labels
    }
    data = { for k, v in var.secret_config_envs : k => base64encode(v) }
  }
}

resource "kubernetes_manifest" "config_files_config_map" {
  manifest = {
    apiVersion = "v1"
    kind       = "ConfigMap"
    metadata = {
      name      = "${var.name}-config-files"
      namespace = var.namespace
      labels    = local.metadata_labels
    }
    data = var.config_files
  }
}

resource "kubernetes_manifest" "config_files_secret" {
  manifest = {
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "${var.name}-config-files"
      namespace = var.namespace
      labels    = local.metadata_labels
    }
    data = { for k, v in var.secret_config_files : k => base64encode(v) }
  }
}

resource "kubernetes_manifest" "general_service_account" {
  manifest = {
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = {
      name      = "${var.name}-general"
      namespace = var.namespace
      labels = merge(local.metadata_labels, {
        "app.kubernetes.io/component" = "general"
      })
    }
  }
}

resource "kubernetes_manifest" "http_server_deployment" {
  manifest = {
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
          serviceAccountName = kubernetes_manifest.general_service_account.object.metadata.name
          containers = [
            {
              name  = "http-server"
              image = "${var.image_repository}:${var.image_tag}"
              envFrom = [
                {
                  configMapRef = {
                    name = kubernetes_manifest.config_envs_config_map.object.metadata.name
                  }
                },
                {
                  secretRef = {
                    name = kubernetes_manifest.config_envs_secret.object.metadata.name
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
                      name = kubernetes_manifest.config_files_config_map.object.metadata.name
                    }
                  },
                  {
                    secret = {
                      name = kubernetes_manifest.config_files_secret.object.metadata.name
                    }
                  },
                ]
              }
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "http_server_horizontal_pod_autoscaler" {
  manifest = {
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
        name       = kubernetes_manifest.http_server_deployment.object.metadata.name
      }
      minReplicas = var.min_http_server_replicas
      maxReplicas = var.max_http_server_replicas
    }
  }
}

resource "kubernetes_manifest" "http_server_service" {
  manifest = {
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
      selector = kubernetes_manifest.http_server_deployment.object.spec.selector.matchLabels
      ports = [
        {
          name       = "http"
          port       = 8080
          protocol   = "TCP"
          targetPort = "http"
        },
      ]
    }
  }
}
