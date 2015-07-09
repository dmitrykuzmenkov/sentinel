# Sentinel
Simple linux tool for monitoring processes written in bash

## Usage
First prepare tasks configs in "tasks" folder. You can find example config of task there.
Start sentinel daemon using command
```bash
cd sentinel-dir && ./sentinel > sentinel.log &
```
Your Sentinel is running and control all proccesses to be run in tasks dir

## Run configuration
You can configure sentinel on run command using special parameters. Parameters using two-dash naming style. For example to make status snapshot to file on each check just run:
```bash
cd sentinel-dir && ./sentinel --status-file=/dev/shm/status.snapshot > sentinel.log 7
```

- *--check-timeout*: timeout in seconds between checks, default is 3
- *--tasks-dir*: folder for tasks config files, default is ./tasks
- *--work-dir*: work dir for Sentinel where it stores log, status, temp files, default is ./proc
- *--pid-file*: Sentinel process pid file, default is $WORK_DIR/sentinel.pid
- *--status-file*: absolute path to file where Sentinel will save status command snapshots on each check of running tasks

For more help and list of all commands use --help option:
```bash
cd sentinel-dir && ./sentinel --help
```

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
- *pid_file*: path where is pid file of running process to check stored
- *start*: valid bash command to start daemon (no foreground)
- *stop*: valid bash command to stop running daemon
- *user*: optional param to run as that user
- *group*: optional param to run task under special group
- *timeout*: timeout in seconds before process will be started
- *memory*: limit memory by this amount, 0 for unlmit or 1024M to limit up to 1024 MB memory use
- *check*: this is custom check on bash when should to stop running task, must return exit code 0 on success

Just create tasks/example file with content above and start Sentinel to monitor it. Remember, no .conf extension and other staff here. Just flat process name.

## Task statuses
There are several statuses for task which writes to Sentinel log file. In log file it looks like:
```
[2015-07-05 01:21:34 UTC] mysql...up
[2015-07-05 01:21:34 UTC] memcached...pending
```

- pending: process is down, Sentinel is trying to start it
- up: process works fine
- memory: get memory limit for process, stopping it to start again
- stopping: custom checks on bash failed for process, stopping it to start again

## Gather info about processes
You can get system status of all running processes.
Run status command without parameters to get system wide info
```bash
cd sentinel-dir && ./status
```

```
Sentinel daemon is up with pid 3194

Host: devcraft
Uptime: 24 hours 33 minutes
Load average: 0.52 0.51 0.45
CPUs: 13.0%us 4.1%sy 0.1%ni 82.5%id 0.1%wa
Memory: 75% of 8080928K (used: 6110376K, free: 1970132K, cached: 993388K)
Swap: 0% of 6139644K (used: 26888K, free: 6112756K)

Tasks: 1

example: up with pid 20779
 State: S (threads: 1, ppid: 2526, uid: 0, gid: 0)
 CPU: 0.0%
 Memory: 14428K with peak of 14428K
 Swap: 0K as of 0%
 Uptime: 14 hours 39 minutes
```

Or run status command with task name to check single task.
```bash
cd sentinel-dir && ./status example
```

```
example: up with pid 20779
 State: S (threads: 1, ppid: 2526, uid: 0, gid: 0)
 CPU: 0.0%
 Memory: 14436K with peak of 14436K
 Swap: 0K as of 0%
 Uptime: 14 hours 49 minutes
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
