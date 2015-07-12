#!/bin/bash
cat <<"EOF"
Sentinel is small tool on bash for monitor proccesses to be run.
Copyright (c) 2015 by Dmitry Kuzmenkov

Usage: sentinel [options]

  --check-timeout          Timeout in seconds between checks. Default: 3

  --tasks-dir              Folder for tasks config files. Default: ./tasks
  --work-dir               Work dir to store log, status, temp files. Default: ./proc
  --status-file            Save status snapshot to file on each check. Default: None
  --pid-file               Sentinel process pid file. Default: $WORK_DIR/sentinel.pid

  --daemonize        -d    Daemonize Sentinel instead of foregroud. Default: not set
  --log-file               Log file for daemon mode. Default: $WORK_DIR/sentinel.log

Daemon commands (remember to use same work dir):

  --reload                 Reload updated task configs
  --stop                   Stop daemonized Sentinel
  --restart                Restart current instance of Sentinel

Gathering info about running processes:

  --status                 Get status of running Sentinel and system
  --status=#               Get status for # task name
  --task-pids              Get pids list of running processes under Sentinel

Other:

  --help             -h    Display this help
EOF
