#!/bin/bash
# Convert string 1024M to bytes
to_bytes() {
  memory=$(echo $1 | grep -oE [0-9]+ || echo 0)
  if echo $1 | grep -i G &> /dev/null; then
    memory=$(( $memory * 1024 * 1024 * 1024 ))
  fi

  if echo $1 | grep -i M &> /dev/null; then
    memory=$(( $memory * 1024 * 1024 ))
  fi

  if echo $1 | grep -i K &> /dev/null; then
    memory=$(( $memory * 1024 ))
  fi
  echo $memory
}
