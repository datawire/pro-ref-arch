# API Authentication using GitHub

This will enable API authentication using GitHub login credentials. It uses [Keycloak](https://www.keycloak.org/) to act as an OpenID Connect authentication server.

1. [Install Ambassador Pro](https://www.getambassador.io/user-guide/install).
2. Register a domain name or get the `External-IP` for your Ambassador service `kubectl get svc ambassador`
3. Create an OAuth application in GitHub.
   * Click on your Profile photo, then choose Settings.
   * Click on Developer Settings.
   * Click on "Register a New Application".
     * The Name can be any value.
     * The Homepage URL should be set to your domain name, or you can use `https://example.com` if you're just testing.
     * The Authorization callback uRL should be `https://${AMBASSADOR_URL}/auth/realms/demo/broker/github/endpoint`.
4. Edit your `env.sh` and add the `CLIENT_ID` and `CLIENT_SECRET` from GitHub:

   ```
   CLIENT_ID=<Client ID from GitHub>
   CLIENT_SECRET=<Client Secret from GitHub>
   ```
5. Replace the `${AMBASSADOR_URL}` values in [00-tenant.yaml](00-tenant.yaml)
6. Run `make apply-api-auth`.
7. Go to `https://${AMBASSADOR_URL}/backend/` in your browser and you will be asked to login. Select the `GitHub` option.
