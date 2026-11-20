# Quick Start - GuestBook Example

Reference: https://book.kubebuilder.io/quick-start

This is a minimal example on how to get up and running.
See [Getting Started](../1-getting-started/) for project structure and controller reconciliation loop notes.

## Initial Scaffolding

```bash
# Bootstrap Project
kubebuilder init --domain example.com --repo example.com/guestbook --project-name guestbook

# Create API
kubebuilder create api --group webapp --version v1 --kind Guestbook

# Make manifests
make manifests
```

When creating API:

- `Create Resource[y]` → will create the files `api/v1/guestbook_types.go`
- `Create Controller[y]` → will create `internal/controllers/guestbook_controller.go`

## Implementation

Scaffold runs as-is; implement in:

- `api/v1/guestbook_types.go` — API: `Spec`/`Status` fields
- `internal/controller/guestbook_controller.go` — logic in `Reconcile()` (replaces the `TODO`)
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

## Tests

`make test` runs envtest-based integration tests against a local API server.

If the `setup-envtest` tool install fails try to add `GOPROXY=direct` flag.

## Running in cluster

```bash
# Building images and deploying (using remote docker registry)
make docker-build docker-push IMG=rafalskolasinski/guestbook-operator:latest
make deploy IMG=rafalskolasinski/guestbook-operator:latest

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
