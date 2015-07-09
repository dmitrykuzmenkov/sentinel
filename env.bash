#!/bin/bash
# Set default values
CHECK_TIMEOUT=3
TASKS_DIR='./tasks'
WORK_DIR='./proc'
PID_FILE=$WORK_DIR'/sentinel.pid'

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
    *) # unknown option
      ;;
  esac
  shift
done

RELOAD_FILE=$WORK_DIR'/reload' # RELOAD config signal
QUIT_FILE=$WORK_DIR'/quit' # QUIT signal
PIDS_FILE=$WORK_DIR'/pids' # All running tasks pids
