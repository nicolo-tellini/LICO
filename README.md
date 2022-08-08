<p align="center" >
<img src="https://github.com/nicolo-tellini/LICO/blob/main/lico3.png">
<p/>

# Description

**LI**nk **CO**ntroller (alias **LICO**) is a configurable utility for monitoring the status of the links of the sotwares that make up a pipeline.

LICO consists of a bash script that perform the monitoring.

LICO relies on:

1) [cron](https://www.digitalocean.com/community/tutorials/how-to-use-cron-to-automate-tasks-ubuntu-1804): a job scheduler;
2) [telegram-send](https://pypi.org/project/telegram-send/): a command-line tool to send messages over Telegram to your account.

While **cron** schedules the frequency at which yuo want to monitor your links status, **telegram-send** sends you a report of the status of your links.

# What you need

1. COPY ```monitor.sh``` inside your ```/favorite/dir ```
2. RENAME ```monitor.sh``` if you want.
3. CRON and TELEGRAM-SEND

## CRON and TELEGRAM-SEND installation
Install both *cron* and *telegram-send* following the installation instructions from the links above,

## Create a BOT on Telegram
From the command line run 
  ```
telegram-send --configure
  ```
the steps to follow will be printed on the shell.

## Configure CRON
*cron* needs to know how frequently you want to run ```monitor.sh```.

Change the configuration file of *cron* running ```crontab -e``` and add, for example:

```
0 0 1 */1 *  bash /favorite/dir/monitor.sh
```

 ```0 0 1 */1 *``` specifies how frequently you want to monitor the links status. <br>
 <br>
The searchbar at [CronTab.guru](https://crontab.guru/) allows you to set your favorite schedule up.<br>
<br>
Using this setup,```monitor.sh``` will silently run in the background on the 1<sup>st</sup> of each month at midnight 🌕.<br>
<br>
At the end of the run, the bot sends the report to your Telegram account.

## Configure ```monitor.sh```

Let's see how monitor a GitHub package.

```
#!/bin/bash

rundir=/favorite/dir/ # this is the path where monitor.sh is stored
pipeline=mypipeline # the name of your pipeline, it is used to send you an apporpriate report on Telegram

soft1=bwa-mem2 # the name of the software we want to check the link status

cd $rundir

mkdir $pipeline

cd $pipeline

# link 1
/usr/bin/time -v git clone --recursive https://github.com/$soft1/$soft1.git 2> $soft1.err

check=$(grep Exit $soft1.err | cut -d":" -f2 | tr -d "[:blank:]")
	if [ $check != 0 ]
	then
	var_sms1=$(echo "Exit")
	else
	var_sms1=$(echo "OK")	
	fi
```

For monitoring additional GitHub repositories you can *copy-paste* the socond part of the script and change the variables according to the new software: 

```
soft2=samtools # the name of the software we want to check the link status

# link 2
/usr/bin/time -v git clone --recursive https://github.com/$soft2/$soft2.git 2> $soft2.err

check=$(grep Exit $soft2.err | cut -d":" -f2 | tr -d "[:blank:]")
	if [ $check != 0 ]
	then
	var_sms2=$(echo "Exit")
	else
	var_sms2=$(echo "OK")	
	fi
```
In this case we changed the name of the variable ```soft1``` with ```soft2``` and ```var_sms1``` with ```var_sms2```.<br>
<br>
NOTE: you can replace ```git clone --recursive https://github.com/$soft2/$soft2.git``` with a more generic ```wget``` followed by the link to the package.<br>
<br>
At the end, you can customize the report either adding or removing quoted ```"text"``` after ```path/to/telegram-send```.

```
path/to/telegram-send "$time" "LICO report" "Pipeline $pipeline:" "$soft1: $var_sms1" "$soft2: $var_sms2"
```
## The OUTPUT

<p align="center" >
<img src="https://github.com/nicolo-tellini/LICO/blob/main/LICO_res.png" width="400" height="800">
<p/>

# RELEASE HISTORY

* v1.0.0 Released on 2023

# DEPENDENCIES

* [cron](https://github.com/samtools/samtools/releases);
* [telegram-send](https://pypi.org/project/telegram-send/).
