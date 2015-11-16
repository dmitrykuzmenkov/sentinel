#!/bin/bash
load_component "measure" "status" "helper"

export PROCESSES=''

# CONFIG load
load_config() {
  println 'Loading task configs'
  echo -n > $PIDS_FILE
  declare -A processes
  # Iterate through all configs
  for file in $TASKS_DIR/*; do
    task="${file##*/}"
    processes["$task"]="$TASKS_DIR/$task"
    test ! -f $WORK_DIR/$task.status && echo 'loading' > $_
  done
  println 'Loaded task configs: '${#processes[@]}
  PROCESSES="${processes[@]}"
}

# Print stdout info
println() {
  echo $(date -u '+[%Y-%m-%d %H:%M:%S %Z]')" $1"
}

# Checking system
spawn_checkers() {
  declare -A pids
  for p_file in $PROCESSES; do
    p_name="${p_file##*/}"
    p_lock="$WORK_DIR/$p_name.lock"
    (
      flock -x -n 9 || exit 1 # already in progress

      # Set defaults variables for task
      timeout=0
      check='exit 0'
      memory=0

      # Load task config
      pid_file="$WORK_DIR/$p_name.pid"
      source "$p_file"

      if [[ -z "$user" ]]; then
        user=$(id -un)
      fi

      if [[ -z "$group" ]]; then
        group=$(id -gn "$user")
      fi

      if [[ -z "$stop" ]]; then
        stop='kill -TERM '$(cat $pid_file)
      fi

      running=$([[ -s $pid_file && -e /proc/$(cat $pid_file) ]] && echo 1 || echo 0)
      status=$([[ "$running" == "1" ]] && echo 'up' || echo 'pending')

      # Do checks on running process
      if [[ "$running" == "1" ]]; then
        # Check memory use
        if (( $(to_bytes "$memory") > 0 && \
          $(to_bytes $(get_memory_usage $(cat $pid_file))) > $(to_bytes "$memory") )); then

          status='memory'
        fi

        # Evaluate custom check using bash
        echo "$check" | bash
        [[ "$?" != "0" ]] && status='stopping'
      fi

      # Save status for current task
      echo $status > $WORK_DIR/$p_name.status

      # Should stop on checks?
      if [[ "$status" == "stopping" || "$status" == "memory" ]]; then
        (
          sudo -u $user -g $group -s -- <<EOF
            exec >> $WORK_DIR/$p_name.log
            exec 2>&1
            exec setsid $stop
EOF
        ) &
      fi

      # Start process in subshell
      if [[ "$running" == "0" ]]; then
        (
          (( $timeout > 0 )) && \
          sleep $timeout; \
          sudo -u $user -g $group -s -- <<EOF
            exec >> $WORK_DIR/$p_name.log
            exec 2>&1
            exec setsid $start & echo \$! > $pid_file
EOF
        ) &
      fi
    ) 9> $p_lock & pids[$p_name]=$!
  done

  #Check finish of all pids
  for p in "${!pids[@]}"; do
    println "$p...$(cat $WORK_DIR/$p.status)"
  done
}

save_status() {
  if [[ -z "$STATUS_FILE" ]]; then
    return 1
  fi

  test -f $STATUS_FILE || touch $_

  (
    flock -x -n 9 || exit 1 # already in progress
    display_system_status > $STATUS_FILE 2>&1
  ) 9> $STATUS_FILE
}
