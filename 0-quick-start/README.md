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

## Running in cluster

```bash
# Install CRDs into the cluster
make install

# Run your controller in the terminal
make run

# Deploy sample application
kubectl apply -k config/samples/

# Building images and deploying
make docker-build docker-push IMG=rafalskolasinski/guestbook-operator:latest
make deploy IMG=rafalskolasinski/guestbook-operator:latest
```
