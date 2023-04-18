output "http_server_host" {
  value = "${kubectl_manifest.http_server_service.name}.svc.cluster.local"
}

output "http_server_port" {
  value = yamldecode(kubectl_manifest.http_server_service.yaml_body_parsed).spec.ports.0.port
}
