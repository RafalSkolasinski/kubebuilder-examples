# Example - Cronjob Example

Reference: https://book.kubebuilder.io/cronjob-tutorial/cronjob-tutorial

Advance example of a CronJob controller.

## Initial Scaffolding

```bash
kubebuilder init --domain tutorial.kubebuilder.io --repo tutorial.kubebuilder.io/cronjob
kubebuilder create api --group batch --version v1 --kind CronJob --resource --controller

make manifests generate
```

## Implementation

- `api/v1/cronjob_types.go` — API: `Spec.Schedule`, `Status.Active`
- `internal/controller/cronjob_controller.go` — reconcile: run and clean up Jobs (helpers at bottom)
- type changes: `make generate manifests`

## Running locally

```bash
# Install CRDs into the cluster
make install

# Run your controller in the terminal
make run

# Deploy sample application
kubectl apply -k config/samples/
```

## Running in cluster

```bash
# Building images and deploying (using remote docker registry)
make docker-build docker-push IMG=rafalskolasinski/cronjob-operator:latest
make deploy IMG=rafalskolasinski/cronjob-operator:latest

# Or using minikube
make docker-build minikube-load deploy restart IMG=controller:dev

# Deploy sample application
kubectl apply -k config/samples/
```

## Cleanup

```bash
make undeploy    # removes controller, RBAC and CRDs (everything deploy installed)
make uninstall   # removes only the CRDs
```

## Other notes

As resource name can clash with regular CronJob, get resources with
```bash
kubectl get cronjobs.batch.tutorial.kubebuilder.io -A
```
