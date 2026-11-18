#!/usr/bin/env bash

set -o errexit
set -o pipefail

function print {
    color_start=$'\e[1;33m'
    color_end=$'\e[0m'
    echo "$color_start$*$color_end"
}

function kubebuilder_version {
    mise ls -c kubebuilder --json | jq .[0].version -r
}

function append_make_targets {
    print "Appending minikube-load, kind-load and restart targets to Makefile ..."
    cat >> Makefile <<'EOF'

.PHONY: minikube-load
minikube-load:
	minikube image load ${IMG}

.PHONY: kind-load
kind-load:
	kind load docker-image ${IMG}

.PHONY: restart
restart:
	$(KUBECTL) rollout restart -n whoami-system deployment/whoami-controller-manager
EOF
}

function generate_example {
    print "Regenerating getting-started example"
    print "Using kubebuilder: $(kubebuilder_version)"

    print "removing project ..."
    rm -rf "project"
    mkdir -p "project"
    cd "project"

    print "Running kubebuilder init ..."
    kubebuilder init --domain example.com --repo example.com/whoami --project-name whoami

    print "Creating API ..."
    kubebuilder create api \
        --group kubebuilder \
        --version v1alpha1 \
        --kind Whoami \
        --image=traefik/whoami:latest \
        --run-as-user="1001" \
        --image-container-port="80" \
        --plugins="deploy-image/v1-alpha"

    append_make_targets
}

generate_example
