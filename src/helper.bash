#!/bin/bash
# Convert string 1024M to bytes
to_bytes() {
  memory=$(echo $1 | grep -oE "[0-9]+" || echo 0)
  case ${1:0,-1} in
    t|T)
      memory=$(( $memory * 1024 * 1024 * 1024 * 1024 ))
      ;;
    g|G)
      memory=$(( $memory * 1024 * 1024 * 1024 ))
      ;;
    m|M)
      memory=$(( $memory * 1024 * 1024 ))
      ;;
    k|K)
      memory=$(( $memory * 1024 ))
      ;;
  esac
  echo $memory
}
