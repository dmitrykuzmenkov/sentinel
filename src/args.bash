#!/bin/bash
# Parse params into bash vars
for p in "$@"; do
  case $p in
    --status-file=*)
      STATUS_FILE="${p#*=}"
      ;;
    --check-timeout=*)
      CHECK_TIMEOUT="${p#*=}"
      ;;
    --tasks-dir=*)
      TASKS_DIR="${p#*=}"
      ;;
    --work-dir=*)
      WORK_DIR="${p#*=}"
      ;;
    --pid-file=*)
      PID_FILE="${p#*=}"
      ;;
    --help)
      HELP=1
      ;;
    *) # unknown option
      ;;
  esac
  shift
done
