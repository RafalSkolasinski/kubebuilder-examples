# Tutorial - Cronjob Example

Reference: https://book.kubebuilder.io/cronjob-tutorial/cronjob-tutorial

Advance example of a CronJob controller.

## Initial Scaffolding

```bash
kubebuilder init --domain tutorial.kubebuilder.io --repo tutorial.kubebuilder.io/cronjob
kubebuilder create api --group batch --version v1 --kind CronJob --resource --controller

make manifests generate
```

## Running in cluster

```bash
# Install CRDs into the cluster
make install

# Run your controller in the terminal
make run

# Deploy sample application
kubectl apply -k config/samples/

# Building images and deploying
make docker-build docker-push IMG=rafalskolasinski/cronjob-operator:latest
make deploy IMG=rafalskolasinski/cronjob-operator:latest
```

## Other notes

As resource name can clash with regular CronJob, get resources with
```bash
kubectl get cronjobs.batch.tutorial.kubebuilder.io -A
```
