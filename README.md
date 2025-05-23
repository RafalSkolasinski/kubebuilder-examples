# Kubebuilder Examples

This is my playground with [Kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) examples from https://book.kubebuilder.io/.

- Executed step by step to illustrate what each step brings in.
- Updates will highlight differences between versions of Kubebuilder.


## Quick Start

- Reference: https://book.kubebuilder.io/quick-start
- Source Code: [0-quick-start](0-quick-start/)

### Initial Scaffolding

```bash
# Bootstrap Project
kubebuilder init --domain my.domain --repo my.domain/guestbook --project-name guestbook

# Create API
kubebuilder create api --group webapp --version v1 --kind Guestbook

# Make manifests
make manifests
```

When creating API:

- `Create Resource[y]` → will create the files `api/v1/guestbook_types.go`
- `Create Controller[y]` → will create `internal/controllers/guestbook_controller.go`

### Running in cluster

```bash
# Install CRDs into the cluster
make install

# Run your controller in the terminal
make run

# Deplyoy sample application
kubectl apply -k config/samples/

# Building images and deploying
make docker-build docker-push IMG=rafalskolasinski/guestbook-operator:latest
make deploy IMG=rafalskolasinski/guestbook-operator:latest
```
### Project Structure

Project files:

- `go.mod` → A new Go module matching our project, with basic dependencies
- `Makefile` → Make targets for building and deploying your controller
- `PROJECT` → Kubebuilder metadata for scaffolding new components
- `cmd/main.go` → main project entrypoint

Where development happens:

- `api/v1/guestbook_types.go` → API is definitions
- `internal/controller/guestbook_controller.go` → reconciliation business logic

Launch configuration:

- `config/default` → Kustomize YAML definitions (CRD, RBAC, controller runtime, etc.)

### **Groups, Versions, Kinds**

- `API Group`: An API Group in Kubernetes is simply a collection of related functionality.
- `API Version`: Each group has one or more versions, which allow us to change how an API works over time.
- `Kinds`: Each API group-version contains one or more API types, which we call Kinds.
- `Resource`: You’ll also hear mention of resources on occasion. A resource is simply a use of a Kind in the API.
- `GroupKindVersion`: This is a kind in a particular group-version (GVK). Each GVK is given root Go type in package.

For example: the `pods` *resource* corresponds to the *Pod* `Kind`.

Notice that resources are always lowercase, and by convention are the lowercase form of the Kind.
