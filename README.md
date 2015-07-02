# Sentinel
Simple linux tool for monitoring processes written in bash

## Usage
First prepare configs in "config" folder. You can find example config there.
Start sentinel daemon using command
```bash
cd sentinel-dir && ./sentinel-daemon > sentinel.log &
```
Your Sentinel is running and control all proccesses to be run in config dir

## Control Sentinel
To control Sentinel you just need to touch special files

### Reload configs
You must send reload signal to Sentinel after you add more proccess to monitor. Its easy:
```bash
cd sentinel-dir && touch proc/reload
```
Done!

### Quit sentinel
Wanna to stop sentinel-daemon? Its not so hard:
```bash
cd sentinel-dir && touch proc/stop
```

### Pids of active processes
You can get all pids of running processes under Sentinel control. Just go to work dir and check pids file:
```bash
cd sentinel-dir && cat proc/pids
```
