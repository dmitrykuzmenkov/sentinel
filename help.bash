#!/bin/bash
# Show help?
test -n "$HELP" && cat <<"EOF"
Usage: ./sentinel [options]

  --check-timeout       Timeout in seconds between checks, default: 3

  --tasks-dir           Folder for tasks config files, default: ./tasks
  --work-dir            Work dir to store log, status, temp files, default: ./proc
  --status-file         Save status snapshot to file on each check, default: None
  --pid-file            Sentinel process pid file, default: $WORK_DIR/sentinel.pid

  --help                Display this help
EOF
test -n "$HELP" && exit 1
