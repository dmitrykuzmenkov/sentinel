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
  print_json_key 'uptime' "$(( $(get_system_uptime) / 3600 )) hours $(( $(get_system_uptime) % 3600 / 60 )) minutes"
  print_json_key 'load_average' "$(get_system_la)"
  print_json_key 'cpus' "$(get_system_cpu_usage)%us $(get_system_cpu_sys)%sy $(get_system_cpu_nice)%ni $(get_system_cpu_idle)%id $(get_system_cpu_wait)%wa"
  print_json_key 'memory' "$(( $(get_system_memory_usage) * 100 / $(get_system_total_memory) ))% of $(get_system_total_memory)K (used: $(get_system_memory_usage)K, free: $(get_system_free_memory)K, cached: $(get_system_cached_memory)K)"
  print_json_key 'swap' "$(( $(get_system_swap_usage) * 100 / $TOTAL_SWAP ))% of ${TOTAL_SWAP}K (used: $(get_system_swap_usage)K, free: $(get_system_free_swap)K)"

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

      print_json_key 'state' "$(get_state $pid) (threads: $(get_threads_count $pid), ppid: $(get_ppid $pid), uid: $(get_uid $pid), gid: $(get_gid $pid))"

      print_json_key 'cpu' "$(get_cpu_usage $pid)%"
      print_json_key 'memory' "$(get_memory_usage $pid)K as of $(( $(get_memory_usage $pid) * 100 / $(get_system_total_memory) ))% with peak of $(get_memory_peak_usage $pid)K"

      print_json_key 'swap' "$(get_swap_usage $pid)K as of $(( $(get_swap_usage $pid) / $TOTAL_SWAP))%"

      uptime_ts=$(( $(date +%s) - $(stat --printf='%Y' $pid_file) ))
      print_json_key 'uptime' "$uptime_ts" 1
    else
      print_json_key 'status' 'down' 1
    fi
  fi
  echo -n '}'
}
