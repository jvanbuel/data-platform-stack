#!/bin/bash

echo "=== Debugging zot registry push issues ==="
echo ""

echo "1. Checking zot pod status:"
kubectl get pods -n services -l app.kubernetes.io/name=zot

echo ""
echo "2. Checking zot service:"
kubectl get svc -n services -l app.kubernetes.io/name=zot

echo ""
echo "3. Checking ingress:"
kubectl get ingress -n services

echo ""
echo "4. Checking ExternalSecret status:"
kubectl get externalsecrets -n services -o wide

echo ""
echo "5. Latest zot logs (last 20 lines):"
kubectl logs -n services -l app.kubernetes.io/name=zot --tail=20

echo ""
echo "6. Traefik logs (looking for 504 errors):"
kubectl logs -n traefik-system -l app.kubernetes.io/name=traefik --tail=20 | grep -E "(504|timeout|error)" || echo "No recent 504/timeout errors in Traefik logs"

echo ""
echo "7. Kubernetes events for zot:"
kubectl get events -n services --field-selector involvedObject.name=$(kubectl get pods -n services -l app.kubernetes.io/name=zot -o jsonpath='{.items[0].metadata.name}') --sort-by='.lastTimestamp'

echo ""
echo "=== To monitor logs in real-time ==="
echo "Zot logs: kubectl logs -n services -l app.kubernetes.io/name=zot -f"
echo "Traefik logs: kubectl logs -n traefik-system -l app.kubernetes.io/name=traefik -f"
