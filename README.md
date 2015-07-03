# Sentinel
Simple linux tool for monitoring processes written in bash

## Usage
First prepare tasks configs in "tasks" folder. You can find example config of task there.
Start sentinel daemon using command
```bash
cd sentinel-dir && ./sentinel > sentinel.log &
```
Your Sentinel is running and control all proccesses to be run in tasks dir

## Configure daemon environment
You can configure settings of Sentinel daemon just editing file "env.bash" in project dir. Its just a simple bash script with defined variables

## Tasks configuration
You need add special config file for task to monitor your process. The example file is simple bash:
```bash
pid_file=$WORK_DIR'/example.pid'
start='while true; do sleep 1; done & echo $! > '$pid_file
stop='kill `cat '$pid_file'`'
user='root'
group='root'
```
- pid_file: path where is pid file of running process to check stored
- start: valid bash command to start daemon (no foreground)
- stop: valid bash command to stop running daemon

Just create tasks/example file with content above and start Sentinel to monitor it. Remember, no .conf extension and other staff here. Just flat process name.

## Gather info about processes
You can get system status of all running processes. Just run bash command 'status' and see example output with various information for example:
```
Sentinel daemon: down

Uptime: 23 hours 29 minutes
Load average: 0.39 0.54 0.53
CPUs: 13.9%us 4.4%sy 0.1%ni 81.4%id 0.1%wa
Memory: 7413972K of 8080928K (free: 666856K)
Swap: 26932K of 6139644K (free: 6112712K)
Tasks: 1

example: up with pid 20779
 State: S
 Parent: 2526
 CPU: 0.0%
 Memory: 14396K with peak of 14396K
 Swap: 0K as of 0%
 Uptime: 13 hours 35 minutes
```

## Control Sentinel
To control Sentinel you just need to touch special files

### Reload configs
You must send reload signal to Sentinel after you add more tasks to monitor. Its easy:
```bash
cd sentinel-dir && touch proc/reload
```
Done!

### Quit sentinel
Wanna to stop sentinel? Its not so hard:
```bash
cd sentinel-dir && touch proc/stop
```

### Pids of active processes
You can get all pids of running processes under Sentinel control. Just go to work dir and check pids file:
```bash
cd sentinel-dir && cat proc/pids
```

