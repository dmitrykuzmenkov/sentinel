#!/bin/bash
color() {
  case "$2" in
    red)
      printf -v text '\e[1;31m%s\e[0;0m' "$1"
      ;;
    green)
      printf -v text '\e[1;32m%s\e[0;0m' "$1"
      ;;
    yellow)
      printf -v text '\e[1;33m%s\e[0;0m' "$1"
      ;;
    blue)
      printf -v text '\e[1;34m%s\e[0;0m' "$1"
      ;;
    purple)
      printf -v text '\e[1;35m%s\e[0;0m' "$1"
      ;;
    cyan)
      printf -v text '\e[1;36m%s\e[0;0m' "$1"
      ;;
    *)
      text="$1"
      ;;
  esac
  test -n "$COLORIZE" && echo -en "$text" || echo -n "$1"
}
