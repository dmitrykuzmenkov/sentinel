#!/bin/bash
export CHECK_TIMEOUT=3
export TASKS_DIR='./tasks'
export WORK_DIR='./proc'
export PID_FILE=$WORK_DIR'/sentinel.pid'
export LOG_FILE=$WORK_DIR'/sentinel.log'

export RELOAD_FILE=$WORK_DIR'/reload' # RELOAD config signal
export QUIT_FILE=$WORK_DIR'/quit' # QUIT signal
export RESTART_FILE=$WORK_FILE'/restart' # RESTAR signal
export PIDS_FILE=$WORK_DIR'/pids' # All running tasks pids

export EDITOR=$(which nano || which vim || which vi)
