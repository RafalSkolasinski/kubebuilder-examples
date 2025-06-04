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
    print "Getting cronjob_types.go"
    wget "$(repo_raw_url)/cronjob-tutorial/testdata/project/api/v1/cronjob_types.go"
    mv cronjob_types.go api/v1/cronjob_types.go

    print "Getting cronjob_controller.go"
    wget "$(repo_raw_url)/cronjob-tutorial/testdata/project/internal/controller/cronjob_controller.go"
    mv cronjob_controller.go internal/controller/cronjob_controller.go

    print "Getting sample CR"
    wget "$(repo_raw_url)/cronjob-tutorial/testdata/project/config/samples/batch_v1_cronjob.yaml"
    mv batch_v1_cronjob.yaml config/samples/batch_v1_cronjob.yaml

    print "Modifying Makefile to set maxDescLen=0 option for CRD generation"
    sed -i '' 's/crd webhook/crd:maxDescLen=0 webhook/g' Makefile
}

function generate_getting_started {
    print "Regenerating getting-started example"
    print "Using kubebuilder: $(kubebuilder_version)"

    print "removing project ..."
    rm -rf "project"
    mkdir -p "project"
    cd "project"

    print "Running kubebuilder init ..."
    kubebuilder init --domain tutorial.kubebuilder.io --repo tutorial.kubebuilder.io/project

    print "Creating API ..."
    kubebuilder create api --group batch --version v1 --kind CronJob --resource --controller

    print "Modifying the example ..."
    modify_getting_started

    print "Generating deepcopy & manifests ..."
    go mod tidy && make generate manifests
}

generate_getting_started
