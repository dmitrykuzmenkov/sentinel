# Sentinel
Simple linux tool for monitoring processes written in bash

## Installing
Clone repository first. Then just build and install with make:
```bash
git clone git@github.com:dmitrykuzmenkov/sentinel.git
cd sentinel
make build
make install
```

Sentinel will be installed to /opt/sentinel dir. You can change this dir using Makefile.

## Usage
Now everything done. Start daemon using command:

```bash
sentinel --start
```

## Run configuration
You can configure sentinel on run command using special parameters. Parameters using two-dash naming style. For example to make status snapshot to file on each check just run:
```bash
sentinel --start --status-file=/dev/shm/status.snapshot --log-file=/var/log/sentinel.log
```

- *--check-timeout*: timeout in seconds between checks, default is 3
- *--tasks-dir*: folder for tasks config files, default is ./tasks
- *--work-dir*: work dir for Sentinel where it stores log, status, temp files, default is ./proc
- *--pid-file*: Sentinel process pid file, default is $WORK_DIR/sentinel.pid
- *--status-file*: absolute path to file where Sentinel will save status command snapshots on each check of running tasks

For more help and list of all commands use --help option:
```bash
sentinel --help
```

## How to manage tasks?
You can add, edit or delete tasks using special commands:

```bash
sentinel --add=task-name
```

```bash
sentinel --edit=task-name
```

```bash
sentinel --delete=task-name
```

The task name must have no spaces and be valid unix filename. Task file consists of special bash params that configure running of the task.

## Tasks configuration
Task file must be in bash format. Its simple flat file with bash vars like this for example:

```bash
start='while true; do sleep 1; done'
stop='kill `cat '$pid_file'`'
user='root'
group='root'
```

You can use $pid_file variable inside config that contains absolute pid file path for your process.

You can omit user, group, stop for example:

```bash
start='while true; do sleep 1; done'
```

In that case pid_file will be $WORK_DIR/example.pid, user and group - root. You can use more options:

- *start*: valid single bash command without any split (;) and multicall (&&, ||) to start daemon (no foreground)
- *stop*: valid bash command to stop running daemon, if not specified using kill with TERM for running pid
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
Use status argument without value to get system wide info
```bash
sentinel --status
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

Or use argument with task name to check single task.
```bash
sentinel --status=example
```

```
example: up with pid 20779
 State: S (threads: 1, ppid: 2526, uid: 0, gid: 0)
 CPU: 0.0%
 Memory: 14436K with peak of 14436K
 Swap: 0K as of 0%
 Uptime: 14 hours 49 minutes
```

If you shell supports for colors u can colorize it:
```bash
sentinel --status --colorize
```

If you want json output just use *--json* flag
```bash
sentinel --status --json
```
* Notice that every storage usage displays in KB not just bytes.
* Notice that every cpu usage displays in percents.

## Control Sentinel
To control Sentinel you just need to call sentinel command with special files

### Reload configs
You must send reload signal to Sentinel after you add more tasks to monitor. Its easy:
```bash
sentinel --reload
```
Done!

### Restart sentinel
If u need to restart daemonized sentinel proccess, you should send restart signal:
```bash
sentinel --restart
```

### Quit sentinel
Wanna to stop sentinel? Its not so hard:
```bash
sentinel --stop
```
