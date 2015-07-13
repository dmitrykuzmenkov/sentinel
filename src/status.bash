#!/bin/bash
load_component "measure"

# Setup commonly used vars
TOTAL_SWAP=$(get_system_total_swap)

# Print label
printlb() {
  echo -n $(color "$1" 'yellow')': '
}

color() {
  case "$2" in
    red)
      printf -v text '\e[1;31m%s\e[0;0m' "$1"
      ;;
    green)
      printf -v text '\e[1;32m%s\e[0;0m' "$1"
      ;;
    yellow)
      printf -v text '\e[1;33m%s\e[0;0m' "$1"
      ;;
    *)
      text="$1"
      ;;
  esac
  test ! -z "$COLORIZE" && echo -en "$text" || echo -n "$1"
}

# Display summary status
display_system_status() {
  # Display header
  echo -ne 'Sentinel daemon is '
  test -e $PID_FILE && SPID=$(cat $_) || SPID=0
  if [[ -e /proc/$SPID ]]; then
    echo $(color 'up' 'green')' with pid '$SPID
  else
    echo $(color 'down' 'red')
  fi

  # Display hostname information
  echo
  printlb 'Host'
  cat /etc/hostname

  printlb 'Uptime'
  echo $(( $(get_system_uptime) / 3600 ))' hours '$(( $(get_system_uptime) % 3600 / 60 ))' minutes'

  printlb 'Load average'
  echo $(get_system_la)

  printlb 'CPUs'
  echo $(get_system_cpu_usage)'%us '$(get_system_cpu_sys)'%sy '$(get_system_cpu_nice)'%ni '$(get_system_cpu_idle)'%id '$(get_system_cpu_wait)'%wa'

  printlb 'Memory'
  echo $(( $(get_system_memory_usage) * 100 / $(get_system_total_memory) ))'% of '$(get_system_total_memory)'K (used: '$(get_system_memory_usage)'K, free: '$(get_system_free_memory)'K, cached: '$(get_system_cached_memory)'K)'

  printlb 'Swap'
  echo $(( $(get_system_swap_usage) * 100 / $TOTAL_SWAP ))'% of '$TOTAL_SWAP'K (used: '$(get_system_swap_usage)'K, free: '$(get_system_free_swap)'K)'

  # Display number of tasks running
  echo
  printlb 'Tasks'
  echo $(ls $TASKS_DIR | wc -l)

  # Show info by tasks
  for task in $(ls $TASKS_DIR); do
    echo
    display_task_status $task
  done
}

# Display status of task
display_task_status() {
  task=$1

  if [[ ! -e "$TASKS_DIR/$task" ]]; then
    echo -e '\e[1;31mNo such task: '$1'\e[0;0m'
    return
  fi

  printlb $task
  source $TASKS_DIR/$task

  pid=$(test -r $pid_file && cat $_ || echo 0)
  if [[ "$pid" == "0" ]]; then
    echo $(color "no read permissions on pid file: $pid_file" 'red')
  else
    if [[ -e /proc/$pid ]]; then
      echo $(color 'up' 'green')' with pid '$pid

      printlb '  State'
      echo $(get_state $pid)' (threads: '$(get_threads_count $pid)', ppid: '$(get_ppid $pid)', uid: '$(get_uid $pid)', gid: '$(get_gid $pid)')'

      printlb '  CPU'
      echo $(get_cpu_usage $pid)'%'

      printlb '  Memory'
      echo $(get_memory_usage $pid)'K as of '$(( $(get_memory_usage $pid) * 100 / $(get_system_total_memory) ))'% with peak of '$(get_memory_peak_usage $pid)'K'

      printlb '  Swap'
      echo $(get_swap_usage $pid)'K as of '$(( $(get_swap_usage $pid) / $TOTAL_SWAP))'%'

      printlb '  Uptime'
      uptime_ts=$(( $(date +%s) - $(stat --printf='%Y' $pid_file) ))
      echo $(( $uptime_ts / 3600 ))' hours '$(( $uptime_ts % 3600 / 60 ))' minutes'

    else
      echo $(color 'down' 'red')
    fi
  fi
}
