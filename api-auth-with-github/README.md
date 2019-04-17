# API Authentication using GitHub

This will enable API authentication using GitHub login credentials. It uses [Keycloak](https://www.keycloak.org/) to act as an OpenID Connect authentication server.

1. Install Ambassador Pro: `make apply-ambassador`.
2. Create an OAuth application in GitHub.
   * Click on your Profile photo, then choose Settings.
   * Click on Developer Settings.
   * Click on "Register a New Application".
     * The Name can be any value.
     * The Homepage URL should be set to your domain name, or you can use `https://example.com` if you're just testing.
     * The Authorization callback uRL should be `https://${AMBASSADOR_IP}/auth/realms/demo/broker/github/endpoint`.
3. Edit your `env.sh` and add the `CLIENT_ID` and `CLIENT_SECRET` from GitHub:

   ```
   CLIENT_ID=<Client ID from GitHub>
   CLIENT_SECRET=<Client Secret from GitHub>
   ```
4. Get the `External-IP` for your Ambassador service `kubectl get svc ambassador`
5. Replace the `${AMBASSADOR_IP}` values in [00-tenant.yaml](00-tenant.yaml)
6. Run `make apply-api-auth`.
7. Go to `https://${AMBASSADOR_IP}/httpbin/headers` in your browser and you will be asked to login. Select the `GitHub` option.
