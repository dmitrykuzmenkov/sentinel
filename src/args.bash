#!/bin/bash
# Parse params into bash vars
parse_args() {
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
      --daemonize|-d)
        DAEMONIZE=1
        ;;
      --log-file=*)
        LOG_FILE="${p#*=}"
        ;;
      --help|-h)
        HELP=1
        ;;
      *) # unknown option
        ;;
    esac
    shift
  done
}
