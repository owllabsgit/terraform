resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.34.1"  # Recommended stable version
  namespace  = "argocd"
  create_namespace = true

  # Use the full path relative to your Terraform root
  values = [file("${path.module}/values/argocd.yaml")]

  # Optional: Set individual values directly
  set {
    name  = "server.service.type"
    value = "NodePort"
  }
}
