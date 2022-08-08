<p align="center" >
<img src="https://github.com/nicolo-tellini/LICO/blob/main/lico3.png">
<p/>

## Description

**LI**nk **CO**ntroller (alias **LICO**) is a configurable utility for monitoring the status of the links of the sotwares that make up a pipeline.

LICO consists of a bash script that perform the monitoring.

LICO relies on:

1) [cron](https://www.digitalocean.com/community/tutorials/how-to-use-cron-to-automate-tasks-ubuntu-1804): a job scheduler;
2) [telegram-send](https://pypi.org/project/telegram-send/): a command-line tool to send messages over Telegram to your account.

While **cron** schedules the frequency at which yuo want to monitor your links status, **telegram-send** sends you a report of the status of your links.

# WHAT YOU NEED

1. COPY ```monitor.sh``` inside your ```/favorite/dir ```
2. RENAME ```monitor.sh``` if you want.

## CRON and TELEGRAM-SEND
Install both *cron* and *telegram-send* following the installation instructions from the links above,

## CREATE A BOT ON TELEGRAM
From the command line run 
  ```
telegram-send --configure
  ```
The steps to follow will be printed on the shell.<br>

## CONFIGURE CRON
*cron* needs to how how frequently you want to run monitoring.
1. Change the configuration tab running ```crontab -e```
2. 

## Release history

* v1.0.0 Released on 2023

## Dependencies

* [cron](https://github.com/samtools/samtools/releases);
* [telegram-send](https://pypi.org/project/telegram-send/).
