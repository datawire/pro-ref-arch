# API Authentication using GitHub

This will enable API authentication using GitHub login credentials. It uses [Keycloak](https://www.keycloak.org/) to act
as an OpenID Connect authentication server.

1. Ensure Ambassador is installed: `make apply-ambassador`
2. Get the `External-IP` for your Ambassador service `kubectl get svc ambassador`
3. Create an OAuth app in GitHub
    - Name: Ambassador Pro Auth Demo
    - Homepage URL: example.com
    - Authorization callback URL: http://${AMBASSADOR_IP}/auth/realms/demo/broker/github/endpoint