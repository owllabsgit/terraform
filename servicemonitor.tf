resource "kubernetes_manifest" "argocd_servicemonitor" {
  manifest = {
    "apiVersion" = "monitoring.coreos.com/v1"
    "kind"       = "ServiceMonitor"
    "metadata" = {
      "name"      = "argocd-servicemonitor"
      "namespace" = "argocd"
      "labels" = {
        "release" = "kube-prometheus-stack"
      }
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app.kubernetes.io/name" = "argocd-server"
        }
      }
      "endpoints" = [
        {
          "port" = "metrics",       # ← Correct port name
          "scheme" = "http",
          "interval" = "30s"
        }
      ],
      "namespaceSelector" = { "any" = true }
    }
  }
}
