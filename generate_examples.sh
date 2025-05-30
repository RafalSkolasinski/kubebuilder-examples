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

function modify_quick_start {
    print "Ensuring goimports is present..."
    go install golang.org/x/tools/cmd/goimports@latest

    local controller_file="internal/controller/guestbook_controller.go"
    local search_pattern="your logic here"
    local placeholder_code="\tfmt.Println(\"Running reconciler logic\")"
    local temp_file="tmp"

    print "Adding placeholder after TODO comment ..."
    awk -v pattern="$search_pattern" -v code="$placeholder_code" \
        '$0 ~ pattern { print; print code; next }1' \
        "$controller_file" > "$temp_file"

    goimports "$temp_file" > "$controller_file"
    rm -f "$temp_file"
}

function generate_quick_start {
    print "Regenerating quick-start example"
    print "Using kubebuilder: $(kubebuilder_version)"

    print "removing project ..."
    rm -rf 0-quick-start
    mkdir 0-quick-start
    cd 0-quick-start

    print "Running kubebuilder init ..."
    kubebuilder init --domain example.com --repo example.com/guestbook --project-name guestbook

    print "Creating API ..."
    kubebuilder create api --group webapp --version v1 --kind Guestbook --resource --controller

    print "Modifying the example ..."
    modify_quick_start

    print "Generating manifests ..."
    make manifests
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
    rm -rf 1-getting-started
    mkdir 1-getting-started
    cd 1-getting-started

    print "Running kubebuilder init ..."
    kubebuilder init --domain example.com --repo example.com/memcached --project-name memcached

    print "Creating API ..."
    kubebuilder create api --group cache --version v1alpha1 --kind Memcached --resource --controller

    print "Modifying the example ..."
    modify_getting_started

    print "Generating deepcopy & manifests ..."
    make generate manifests
}

generate_quick_start
generate_getting_started
