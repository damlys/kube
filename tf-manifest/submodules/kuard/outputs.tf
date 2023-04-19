output "http_server_host" {
  value = "${kubernetes_manifest.http_server_service.object.metadata.name}.${kubernetes_manifest.http_server_service.object.metadata.namespace}.svc.cluster.local"
}

output "http_server_port" {
  value = kubernetes_manifest.http_server_service.object.spec.ports.0.port
}
