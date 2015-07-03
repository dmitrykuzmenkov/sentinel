# Sentinel
Simple linux tool for monitoring processes written in bash

## Usage
First prepare configs in "config" folder. You can find example config there.
Start sentinel daemon using command
```bash
cd sentinel-dir && ./sentinel > sentinel.log &
```
Your Sentinel is running and control all proccesses to be run in config dir

## Configure daemon environment
You can configure settings of Sentinel daemon just editing file "env.bash" in project dir. Its just a simple bash script with defined variables

## Config files
You need add special config file to monitor your process. The example file is simple bash:
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

Just create config/example file with content above and start Sentinel to monitor it. Remember, no .conf extension and other staff here. Just flat process name.

## Control Sentinel
To control Sentinel you just need to touch special files

### Reload configs
You must send reload signal to Sentinel after you add more proccess to monitor. Its easy:
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

