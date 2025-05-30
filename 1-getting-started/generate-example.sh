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

function repo_raw_url {
    echo "https://raw.githubusercontent.com/kubernetes-sigs/kubebuilder/refs/tags/v$(kubebuilder_version)/docs/book/src"
}


function modify_getting_started {
    print "Getting memcached_types.go"
    wget "$(repo_raw_url)/getting-started/testdata/project/api/v1alpha1/memcached_types.go"
    mv memcached_types.go api/v1alpha1/memcached_types.go

    print "Getting memcached_types.go"
    wget "$(repo_raw_url)/getting-started/testdata/project/internal/controller/memcached_controller.go"
    mv memcached_controller.go internal/controller/memcached_controller.go
}

function generate_getting_started {
    print "Regenerating getting-started example"
    print "Using kubebuilder: $(kubebuilder_version)"

    print "removing project ..."
    rm -rf "project"
    mkdir -p "project"
    cd "project"

    print "Running kubebuilder init ..."
    kubebuilder init --domain example.com --repo example.com/memcached --project-name memcached

    print "Creating API ..."
    kubebuilder create api --group cache --version v1alpha1 --kind Memcached --resource --controller

    print "Modifying the example ..."
    modify_getting_started

    print "Generating deepcopy & manifests ..."
    make generate manifests
}

generate_getting_started
