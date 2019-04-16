# API Authentication using GitHub

This will enable API authentication using GitHub login credentials. It uses [Keycloak](https://www.keycloak.org/) to act
as an OpenID Connect authentication server.

1. Ensure Ambassador is installed: `make apply-ambassador`
2. Get the `External-IP` for your Ambassador service `kubectl get svc ambassador`
3. Create an OAuth app in GitHub
    - Name: Ambassador Pro Auth Demo
    - Homepage URL: `example.com`
    - Authorization callback URL: http://${AMBASSADOR_IP}/auth/realms/demo/broker/github/endpoint
4. Add to `env.sh` the following environment variables:

```bash

CLIENT_ID=<Client ID from GitHub>
CLIENT_SECRET=<Client Secret from GitHub>
```

5. Replace the `${AMBASSADOR_IP}` values in [00-tenant.yaml](00-tenant.yaml)
6. Run `make apply-api-auth`
7. Go to `https://${AMBASSADOR_IP}/httpbin/headers` and you will be asked to login. Select the `GitHub` option.
