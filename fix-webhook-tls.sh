#!/bin/bash
set -e

NAMESPACE="tekton-pipelines"

echo "🔧 Fixing Tekton webhook certificate issue in namespace: $NAMESPACE"

# Delete webhook cert secrets (they will be recreated automatically)
echo "🗑️  Deleting expired secrets..."
kubectl delete secret -n $NAMESPACE tekton-webhook-certs --ignore-not-found
kubectl delete secret -n $NAMESPACE tekton-pipelines-webhook-certs --ignore-not-found
kubectl delete secret -n $NAMESPACE tekton-operator-webhook-certs --ignore-not-found

# Restart webhook and controller pods
echo "♻️  Restarting Tekton webhook and controller..."
kubectl delete pod -n $NAMESPACE -l app=tekton-pipelines-webhook --ignore-not-found
kubectl delete pod -n $NAMESPACE -l app=tekton-pipelines-controller --ignore-not-found

# Wait for pods to restart
echo "⏳ Waiting for Tekton pods to restart..."
kubectl rollout status deployment/tekton-pipelines-webhook -n $NAMESPACE
kubectl rollout status deployment/tekton-pipelines-controller -n $NAMESPACE

echo "✅ Tekton webhook certificates refreshed successfully!"

