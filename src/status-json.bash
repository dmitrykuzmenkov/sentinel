#!/bin/bash
load_component "measure"

# Setup commonly used vars
TOTAL_SWAP=$(get_system_total_swap)

# Print label
print_json_key() {
  echo -n '"'$1'": '
  [[ $2 =~ ^[0-9]+$ ]] && echo -n "$2" || echo -n '"'$2'"'
  [[ -z "$3" ]] && echo -n ','
}

# Display summary status
display_system_status() {
  echo -n '{'
  test -e $PID_FILE && SPID=$(cat $_) || SPID=0
  if [[ -e /proc/$SPID ]]; then
    print_json_key 'status' 'up'
  else
    print_json_key 'status' 'up'
  fi

  print_json_key 'pid' "$SPID"

  # Display hostname information
  print_json_key 'host' "$(cat /etc/hostname)"
  print_json_key 'uptime' "$(get_system_uptime)"
  print_json_key 'load_average' "$(get_system_la)"
  print_json_key 'cpu_usage' "$(get_system_cpu_usage)"
  print_json_key 'cpu_system' "$(get_system_cpu_sys)"
  print_json_key 'cpu_nice' "$(get_system_cpu_nice)"
  print_json_key 'cpu_idle' "$(get_system_cpu_idle)"
  print_json_key 'cpu_wait' "$(get_system_cpu_wait)"
  print_json_key 'memory_usage' "$(get_system_memory_usage)"
  print_json_key 'memory_usage_percent' "$(( $(get_system_memory_usage) * 100 / $(get_system_total_memory) ))"
  print_json_key 'memory_total' "$(get_system_total_memory)"
  print_json_key 'memory_free' "$(get_system_free_memory)"
  print_json_key 'memory_cached' "$(get_system_cached_memory)"
  print_json_key 'swap_usage' "$(get_system_swap_usage)"
  print_json_key 'swap_usage_percent' "$(( $(get_system_swap_usage) * 100 / $TOTAL_SWAP ))"
  print_json_key 'swap_total' "${TOTAL_SWAP}"
  print_json_key 'swap_free' "$(get_system_free_swap)"

  task_count=$(ls $TASKS_DIR | wc -l)
  print_json_key 'task_count' "$task_count"

  echo -n '"task_list": ['
  # Show info by tasks
  local i=0
  for task in $(ls $TASKS_DIR); do
    display_task_status $task
    [[ $((++i)) < $task_count ]] && echo -n ','
  done
  echo -n ']'
  echo -n '}'
}

# Display status of task
display_task_status() {
  task=$1

  if [[ ! -e "$TASKS_DIR/$task" ]]; then
    echo -n '{'
    print_json_key 'error' "No such task: $1" 1
    echo -n '}'
    return
  fi

  pid_file="$WORK_DIR/$task.pid"
  source $TASKS_DIR/$task
  # Check vars
  if [[ -z "$start" ]]; then
    echo -n '{'
    print_json_key 'error' 'Wrong config. It must define at least these vars: start' 1
    echo -n '}'
    return
  fi

  echo -n '{'
  print_json_key 'task' "$task"
  pid=$(test -r $pid_file && cat $_ || echo 0)
  if [[ "$pid" == "0" ]]; then
    print_json_key 'error' "no read permissions on pid file: $pid_file" 1
  else
    if [[ -e /proc/$pid ]]; then
      print_json_key 'status' 'up'
      print_json_key 'pid' "$pid"

      print_json_key 'state' "$(get_state $pid)"
      print_json_key 'threads' "$(get_threads_count $pid)"
      print_json_key 'ppid' "$(get_ppid $pid)"
      print_json_key 'uid' "$(get_uid $pid)"
      print_json_key 'gid' "$(get_gid $pid)"

      print_json_key 'cpu_usage' "$(get_cpu_usage $pid)"
      print_json_key 'memory_usage' "$(get_memory_usage $pid)"
      print_json_key 'memory_usage_percent' "$(( $(get_memory_usage $pid) * 100 / $(get_system_total_memory) ))"
      print_json_key 'memory_peak' "$(get_memory_peak_usage $pid)"

      print_json_key 'swap_usage' "$(get_swap_usage $pid)"
      print_json_key 'swap_usage_percent' "$(( $(get_swap_usage $pid) / $TOTAL_SWAP))"

      uptime_ts=$(( $(date +%s) - $(stat --printf='%Y' $pid_file) ))
      print_json_key 'uptime' "$uptime_ts" 1
    else
      print_json_key 'status' 'down' 1
    fi
  fi
  echo -n '}'
}
