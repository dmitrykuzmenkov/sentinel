#!/bin/bash

# Status info by process
get_cpu_usage() {
  ps -p $1 -o %cpu | tail -n1 | tr -d ' '
}
get_memory_usage() {
  _get_status_param $1 'VmSize'
}
get_memory_peak_usage() {
  _get_status_param $1 'VmPeak'
}
get_swap_usage() {
  _get_status_param $1 'VmSwap'
}
get_ppid() {
  _get_status_param $1 'PPid'
}
get_uid() {
  _get_status_param $1 'Uid'
}
get_gid() {
  _get_status_param $1 'Gid'
}
get_threads_count() {
  _get_status_param $1 'Threads'
}
get_state() {
  _get_status_param $1 'State'
}
# params: pid, key-param
_get_status_param() {
  cat /proc/$1/status | grep ^$2':' | awk '{print $2}'
}

# System wide functions

# Cpu metrics
get_system_cpu_usage() {
  _get_system_cpu_info | awk '{print $1}'
}
get_system_cpu_sys() {
  _get_system_cpu_info | awk '{print $2}'
}
get_system_cpu_nice() {
  _get_system_cpu_info | awk '{print $3}'
}
get_system_cpu_idle() {
  _get_system_cpu_info | awk '{print $4}'
}
get_system_cpu_wait() {
  _get_system_cpu_info | awk '{print $5}'
}
_get_system_cpu_info() {
  top -bn1 | head -n3 | tail -n1 | awk '{print $2" "$4" "$6" "$8" "$10}'
}

# Memory metrics
get_system_total_memory() {
  _get_system_memory_param 'MemTotal'
}
get_system_free_memory() {
  _get_system_memory_param 'MemFree'
}
get_system_cached_memory() {
  _get_system_memory_param 'Cached'
}
get_system_memory_usage() {
  echo $(($(get_system_total_memory $1) - $(get_system_free_memory $1)))
}

# Swap metrics
get_system_total_swap() {
  _get_system_memory_param 'SwapTotal'
}
get_system_free_swap() {
  _get_system_memory_param 'SwapFree'
}
get_system_swap_usage() {
  echo $(($(get_system_total_swap $1) - $(get_system_free_swap $1)))
}
_get_system_memory_param() {
  cat /proc/meminfo | grep ^$1':' | awk '{print $2}'
}

# Common system metrics
get_system_la() {
 cat /proc/loadavg | awk '{print $1" "$2" "$3}'
}
# System uptime in seconds
get_system_uptime() {
  cat /proc/uptime | tr '.' ' ' | awk '{print $1}'
}
