#!/bin/bash -exu

function main() {
  local root_dir
  root_dir=${1}

  pushd "${root_dir}/infrastructure-ci-bbl-states/infra-ci" > /dev/null
    bbl plan --lb-type concourse
    bbl up
  popd > /dev/null

}

function commit_bbl_state() {
  local root_dir
  root_dir=${1}

  local bbl_commit

  pushd "${root_dir}/bosh-bootloader" > /dev/null
    bbl_commit=$(git rev-parse HEAD)
  popd > /dev/null

  pushd "${root_dir}/infrastructure-ci-bbl-states/infra-ci" > /dev/null

    git config --global user.email "ifra@pivotal.io"
    git config --global user.name "Infra CI Bot"

    git add .
    git commit -m "update concourse bbl director to bbl commit ${bbl_commit}"
  popd > /dev/null

}

trap 'commit_bbl_state "${root_dir}"' EXIT

main ${PWD}