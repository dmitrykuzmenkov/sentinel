#!/bin/bash
# Parse params into bash vars
parse_args() {
  for p in "$@"; do
    case $p in
      --status-file=*)
        export STATUS_FILE=$(readlink -f "${p#*=}")
        ;;
      --check-timeout=*)
        export CHECK_TIMEOUT="${p#*=}"
        ;;
      --tasks-dir=*)
        export TASKS_DIR=$(readlink -f "${p#*=}")
        ;;
      --work-dir=*)
        export WORK_DIR=$(readlink -f "${p#*=}")
        ;;
      --pid-file=*)
        export PID_FILE=$(readlink -f "${p#*=}")
        ;;
      --log-file=*)
        export LOG_FILE=$(readlink -f "${p#*=}")
        ;;
      --start)
        export ARG_START=1
        ;;
      --stop)
        export ARG_STOP=1
        ;;
      --reload)
        export ARG_RELOAD=1
        ;;
      --restart)
        export ARG_RESTART=1
        ;;
      --status)
        export ARG_STATUS_ALL=1
        ;;
      --status=*)
        export ARG_STATUS="${p#*=}"
        ;;
      --colorize)
        export COLORIZE=1
        ;;
      --add=*)
        export ARG_ADD="${p#*=}"
        ;;
      --edit=*)
        export ARG_EDIT="${p#*=}"
        ;;
      --delete=*)
        export ARG_DELETE="${p#*=}"
        ;;
      --task-example)
        export TASK_EXAMPLE=1
        ;;
      --version|-v)
        export ARG_VERSION=1
        ;;
      --help|-h)
        export ARG_HELP=1
        ;;
      *) # unknown option
        ;;
    esac
  done
}
