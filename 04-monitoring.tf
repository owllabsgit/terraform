resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  create_namespace = true

  values = [<<EOF
# Monitor all namespaces
prometheus:
  prometheusSpec:
    podMonitorNamespaceSelector: {}
    probeNamespaceSelector: {}
    ruleNamespaceSelector: {}
    serviceMonitorNamespaceSelector: {}

# Optional: Also scrape all services/endpoints in all namespaces
# (only if they have correct ServiceMonitors or annotations)
serviceMonitor:
  selector:
    matchLabels: {}
  namespaceSelector:
    any: true

# Optional: Enable scraping of all Pods with Prometheus annotations
podMonitor:
  namespaceSelector:
    any: true

# Optional: Grafana settings (not required for monitoring)
grafana:
  enabled: true
EOF
  ]
}
