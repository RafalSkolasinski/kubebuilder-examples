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
}

generate_example
