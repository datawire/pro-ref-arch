# Ambassador Pro Dev Portal and Example Service

This will install the Ambassador Pro Dev Portal

1. Install Ambassador Pro: `make apply-ambassador`.
2. Get the `External-IP` for your Ambassador service `kubectl get svc ambassador`
3. Replace the `${AMBASSADOR_IP}` values in [01-dev-portal.yaml](01-dev-portal.yaml)
4. Run `make apply-dev-portal`
5. Goto `https://${AMBASSADOR_IP}/docs`

# Getting a custom service in the Dev Portal

You can easily register a new or existing service with the Dev Portal. You must expose an OpenAPI 3.0 schema document
at the `/.ambassador-internal/openapi-docs` path for this to work. Once you do that your service will automatically
appear in the Dev Portal list.

