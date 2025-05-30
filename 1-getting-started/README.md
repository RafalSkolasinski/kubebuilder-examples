# Getting Started - Memcached Example

Reference: https://book.kubebuilder.io/getting-started

A little more involved example that creates Memcached deployments.
See also [operator-sdk tutorial](https://sdk.operatorframework.io/docs/building-operators/golang/tutorial/) which adds a finalizer to a similar controller.

## Getting up & running

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

API and controller implementation is taken directly from upstream example, see [generate-example.sh](./generate-example.sh) script for details.

### Running in cluster

```bash
# Install CRDs into the cluster
make install

# Run your controller in the terminal
make run

# Deploy sample application
kubectl apply -k config/samples/

# Building images and deploying
make docker-build docker-push IMG=rafalskolasinski/kubebuilder-memcached-operator:latest
make deploy IMG=rafalskolasinski/kubebuilder-memcached-operator:latest
```

## Project Structure

Project files:

- `go.mod` → A new Go module matching our project, with basic dependencies
- `Makefile` → Make targets for building and deploying your controller
- `PROJECT` → Kubebuilder metadata for scaffolding new components
- `cmd/main.go` → main project entrypoint

Where development happens:

- `api/v1/memcached_types.go` → API is definitions
- `internal/controller/memcached_controller.go` → reconciliation business logic

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


## Reconciliation Process

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
