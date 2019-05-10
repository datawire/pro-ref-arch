# Ambassador Pro Dev Portal and Example Service

This will install the Ambassador Pro Dev Portal

1. Install Ambassador Pro: `make apply-ambassador`.
2. Get the `External-IP` for your Ambassador service `kubectl get svc ambassador`
3. Replace the `${AMBASSADOR_IP}` values in [01-dev-portal.yaml](01-dev-portal.yaml)
4. Run `make apply-dev-portal`