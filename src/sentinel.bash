#!/bin/bash
load_component "measure" "helper"

# CONFIG load
load_config() {
  println 'Loading task configs'
  # Clean staff
  unset $PROCESSES
  echo -n > $PIDS_FILE

  # Iterate through all configs
  for file in $(ls $TASKS_DIR); do
    PROCESSES["$file"]=$TASKS_DIR/$file
    source $TASKS_DIR/$file
    test -f $pid_file && echo $(cat $_) >> $PIDS_FILE
    test ! -f $WORK_DIR/$file.status && echo 'loading' > $_
  done
  println 'Loaded task configs: '${#PROCESSES[@]}
}

# Print stdout info
println() {
  echo $(date -u '+[%Y-%m-%d %H:%M:%S %Z]')" $1"
}

# Checking system
spawn_checkers() {
  declare -A pids
  for p in ${!PROCESSES[@]}; do
    (
      flock -n 9 || exit 1 # already in progress

      # Set defaults variables for task
      user=$(id -un)
      group=$(id -gn)
      timeout=0
      check='exit 0'
      memory=0

      # Load task config
      source ${PROCESSES[$p]}
      running=$([[ -s $pid_file && -e /proc/$(cat $pid_file) ]] && echo 1 || echo 0)
      status=$([[ "$running" == "1" ]] && echo 'up' || echo 'pending')

      # Do checks on running process
      if [[ "$running" == "1" ]]; then
        # Check memory use
        if (( $(to_bytes "$memory") > 0 && $(to_bytes $(get_memory_usage $(cat $pid_file))) > $(to_bytes "$memory") )); then
          status='memory'
        fi

        # Evaluate custom check using bash
        echo "$check" | bash
        [[ "$?" != "0" ]] && status='stopping'
      fi

      # Save status for current task
      echo $status > $WORK_DIR/$p.status

      # Should stop on checks?
      if [[ "$status" == "stopping" || "$status" == "memory" ]]; then
        (echo "$stop" | sudo -u $user -g $group bash 2>&1 >> $WORK_DIR/$p.log &)
      fi

      # Start process in subshell
      if [[ "$running" == "0" ]]; then
        ((( $timeout > 0 )) && sleep $timeout; echo "$start" | sudo -u $user -g $group bash 2>&1 >> $WORK_DIR/$p.log &)
        fi
    ) 9< ${PROCESSES[$p]} & pids[$p]=$!
  done

  #Check finish of all pids
  for p in ${!pids[@]}; do
    println "$p...$(cat $WORK_DIR/$p.status)"
  done
}

save_status() {
  if [[ -z "$STATUS_FILE" ]]; then
    return 1
  fi

  test ! -e $STATUS_FILE && touch $STATUS_FILE || return 1

  (
    flock -n 9 || exit 1 # already in progress

    ./status 2>&1 > $STATUS_FILE
  ) 9< $STATUS_FILE
}