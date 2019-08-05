# Upgrading to Ambassador Pro

Ambassador Pro is typically deployed as a sidecar service to Ambassador. This allows for Ambassador to communicate with the Pro services locally. 

While this is the preferred deployment topology, Ambassador Pro can also be deployed as a separate service. Ambassador will then communicate with it via a Kubernetes service. This allows for an easy deployment for open source users to evaluate Ambassador Pr.

The `??-ambassador-pro*.yaml` files in this directory contains all of the necessary resources to easily upgrade Ambassador open source to Ambassador Pro.

## Considerations

- This is only for upgrading from an existing open source implementation of Ambassador. Use the [normal Ambassador Pro installation](https://www.getambassador.io/user-guide/ambassador-pro-install) if this is your first time using Ambassador.

- Ambassador Pro will replace your current `AuthService` implementation. Remove your current `AuthService` annotation before deploying Ambassador Pro. If you would like to keep your current `AuthService`, remove the `AuthService` annotation from the `ambassador-pro.yaml` file.

- Deploying Ambassador Pro as a separate Kubernetes service will increase latency and should only be used for evaluation purposes. We recommend moving to the sidecar model after completing evaluation.


## Deploy Ambassador Pro 

You can deploy Ambassador Pro with the `Makefile` in the root of this repository:

```sh
make apply-upgrade-to-pro
```
