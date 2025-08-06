resource "kubectl_manifest" "tekton_namespace" {
  yaml_body = <<-YAML
    apiVersion: v1
    kind: Namespace
    metadata:
      name: tekton-pipelines
  YAML
}

resource "null_resource" "install_tekton" {
  depends_on = [kubectl_manifest.tekton_namespace]

  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
      kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
      kubectl apply -f https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml
    EOT
  }
}

output "tekton_status" {
  value = <<-EOT
    Tekton installed successfully!
    Check pods with: kubectl get pods -n tekton-pipelines --watch
    Dashboard URL (if enabled): http://localhost:9097 (use port-forward)
  EOT
}
