#!/bin/bash
export VERSION='0.2.1'
export CHECK_TIMEOUT=3
export TASKS_DIR=$(readlink -f './tasks')
export WORK_DIR=$(readlink -f './proc')
export PID_FILE=$WORK_DIR'/sentinel.pid'
export LOG_FILE=$WORK_DIR'/sentinel.log'

export PIDS_FILE=$WORK_DIR'/pids' # All running tasks pids

export EDITOR=$(which nano 2> /dev/null || which vim 2> /dev/null || which vi)
