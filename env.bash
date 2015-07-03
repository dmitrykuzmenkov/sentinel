#!/bin/bash
PID_FILE="$0.pid" # Saved in $WORK_DIR
CHECK_TIMEOUT=3
TASKS_DIR='./tasks'
WORK_DIR='./proc'
RELOAD_FILE=$WORK_DIR'/reload' # RELOAD config signal
QUIT_FILE=$WORK_DIR'/quit' # QUIT signal
PIDS_FILE=$WORK_DIR'/pids' # All running tasks pids
