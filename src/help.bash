#!/bin/bash
cat <<"EOF"
Sentinel is small tool on bash for monitor proccesses to be run.
Copyright (c) 2015 by Dmitry Kuzmenkov

Usage: ./sentinel [options]

  --check-timeout          Timeout in seconds between checks, default: 3

  --tasks-dir              Folder for tasks config files, default: ./tasks
  --work-dir               Work dir to store log, status, temp files, default: ./proc
  --status-file            Save status snapshot to file on each check, default: None
  --pid-file               Sentinel process pid file, default: $WORK_DIR/sentinel.pid

  --daemonize        -d    Daemonize Sentinel instead of foregroud. Default: not set
  --log-file               Log file for daemon mode. Default: $WORK_DIR/sentinel.log

  --help             -h    Display this help
EOF
