# Kubebuilder Examples

This is my playground with [Kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) examples from https://book.kubebuilder.io.

- Executed step by step to illustrate what each step brings in.
- Updates will highlight differences between versions of Kubebuilder.

## References
- About Operator Pattern: https://kubernetes.io/docs/concepts/extend-kubernetes/operator/
- About Controllers: https://kubernetes.io/docs/concepts/architecture/controller/


## Quick Start

- Reference: https://book.kubebuilder.io/quick-start
- Source Code: [0-quick-start](0-quick-start/)

### Initial Scaffolding

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


## Getting Started

- Reference: https://book.kubebuilder.io/getting-started
- Source Code: [1-getting-started](1-getting-started/)
- See also [operator-sdk tutorial](https://sdk.operatorframework.io/docs/building-operators/golang/tutorial/) which adds finalizer

### Initial Scaffolding

```bash
# Bootstrap Project
kubebuilder init --domain example.com --repo example.com/memcached --project-name memcached

# Create API
kubebuilder create api --group cache --version v1alpha1 --kind Memcached
```

### Implementing API

After creating AP need to generate manifests with the specs and validations.

To generate all required files:

- Run `make generate` to create the `DeepCopy` implementations in `api/v1alpha1/zz_generated.deepcopy.go`.
- Then, run `make manifests` to generate the CRD manifests under `config/crd/bases` and a sample under `config/crd/samples`.

Both commands use [controller-gen](https://book.kubebuilder.io/reference/controller-gen) with different flags for code and manifest generation, respectively.

### Reconciliation Process

Here’s a pseudo-code example to illustrate reconciliation loop:
```go
reconcile App {
  // Check if a Deployment for the app exists, if not, create one
  // If there's an error, then restart from the beginning of the reconcile
  if err != nil {
    return reconcile.Result{}, err
  }

  // Check if a Service for the app exists, if not, create one
  // If there's an error, then restart from the beginning of the reconcile
  if err != nil {
    return reconcile.Result{}, err
  }

  // Look for Database CR/CRD an check the Database Deployment's replicas size
  // If deployment.replicas size doesn't match cr.size, then update it
  // Then, restart from the beginning of the reconcile. For example, by returning `reconcile.Result{Requeue: true}, nil`.
  if err != nil {
    return reconcile.Result{Requeue: true}, nil
  }
  ...

  // If at the end of the loop:
  // Everything was executed successfully, and the reconcile can stop
  return reconcile.Result{}, nil
}
```

The following are a few possible return options to restart the Reconcile:
```go
// With the error:
return ctrl.Result{}, err

// Without an error:
return ctrl.Result{Requeue: true}, nil

// Therefore, to stop the Reconcile, use:
return ctrl.Result{}, nil

//Reconcile again after X time:
return ctrl.Result{RequeueAfter: nextRun.Sub(r.Now())}, nil
```
