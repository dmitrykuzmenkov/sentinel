#!/bin/bash
CHECK_TIMEOUT=${CHECK_TIMEOUT-3}
TASKS_DIR=${TASKS_DIR-'./tasks'}
WORK_DIR=${WORK_DIR-'./proc'}
PID_FILE=${PID_FILE-"$WORK_DIR/sentinel.pid"}

RELOAD_FILE=$WORK_DIR'/reload' # RELOAD config signal
QUIT_FILE=$WORK_DIR'/quit' # QUIT signal
PIDS_FILE=$WORK_DIR'/pids' # All running tasks pids
