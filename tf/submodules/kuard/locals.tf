locals {
  selector_labels = {
    "app.kubernetes.io/instance" = var.name
    "app.kubernetes.io/name"     = trim(substr(replace(var.image_name, "/[\\W]/", "_"), 0, 63), "_")
  }
  metadata_labels = merge(local.selector_labels, {
    "app.kubernetes.io/version" = trim(substr(replace(var.image_tag, "/[\\W]/", "_"), 0, 63), "_")
  })
}
