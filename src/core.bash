#!/bin/bash
declare -A _COMPONENTS
load_component() {
  for p in "$@"; do
    if [[ -z "${_COMPONENTS["$p"]}" ]]; then
      source ./src/$p.bash
    fi
  done
}

# Load default components
load_component "env"
