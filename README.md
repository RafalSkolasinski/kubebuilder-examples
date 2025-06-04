# Kubebuilder Examples

This is my playground with [Kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) examples from https://book.kubebuilder.io.

- Executed step by step to illustrate what each step brings in.
- Updates will highlight differences between versions of Kubebuilder.

## References
- About Operator Pattern: https://kubernetes.io/docs/concepts/extend-kubernetes/operator/
- About Controllers: https://kubernetes.io/docs/concepts/architecture/controller/

## Examples

- [Quick Start: GuestBook](./0-quick-start/) - bare-bone controller that illustrated initial scaffolding
- [Getting Started: Memcached](./1-getting-started/) - simple controller that creates Memcached deployments
- [Tutorial: CronJob Operator](./2-cronjob/) - advanced example


## Playground environment.

- required tools are defined via https://mise.jdx.dev/
- testing cluster: standard Minikube should do


## License

Kubebuilder examples are governed by their own license. Anything on top, see [LICENSE](./LICENSE).
