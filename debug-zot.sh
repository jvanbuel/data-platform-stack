#!/bin/bash

echo "=== Debugging applications ==="
echo ""

echo "1. Checking PostgreSQL cluster status:"
kubectl get postgrescluster -n services

echo ""
echo "2. Checking PostgreSQL secrets (Crunchy-generated):"
kubectl get secrets -n services | grep pguser

echo ""
echo "3. Checking zot pod status:"
kubectl get pods -n services -l app.kubernetes.io/name=zot

echo ""
echo "4. Checking zitadel pod status:"
kubectl get pods -n services -l app.kubernetes.io/name=zitadel

echo ""
echo "5. Checking services:"
kubectl get svc -n services

echo ""
echo "6. Checking ingress:"
kubectl get ingress -n services

echo ""
echo "7. Checking ExternalSecret status:"
kubectl get externalsecrets -n services -o wide

echo ""
echo "8. Latest zot logs (last 10 lines):"
kubectl logs -n services -l app.kubernetes.io/name=zot --tail=10

echo ""
echo "9. Latest zitadel logs (last 10 lines):"
kubectl logs -n services -l app.kubernetes.io/name=zitadel --tail=10

echo ""
echo "10. Traefik logs (looking for 504 errors):"
kubectl logs -n traefik-system -l app.kubernetes.io/name=traefik --tail=20 | grep -E "(504|timeout|error)" || echo "No recent 504/timeout errors in Traefik logs"

echo ""
echo "=== To monitor logs in real-time ==="
echo "Zot logs: kubectl logs -n services -l app.kubernetes.io/name=zot -f"
echo "Zitadel logs: kubectl logs -n services -l app.kubernetes.io/name=zitadel -f"
echo "PostgreSQL logs: kubectl logs -n services -l postgres-operator.crunchydata.com/cluster=my-cute-postgres-cluster -f"
