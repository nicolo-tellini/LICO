<p align="center" >
<img src="https://github.com/nicolo-tellini/LICO/blob/main/lico3.png">
<p/>

# Description

**LI**nk **CO**ntroller (alias **LICO**) is a configurable utility for monitoring the link integrity.

LICO consists of a bash script that identifies broken links.

LICO relies on:

1) *cron*: a job scheduler;
2) *telegram-send*: a command-line tool to send messages over Telegram to your account.

While **cron** schedules the frequency at which you want to monitor your link status, **telegram-send** notifies you with a multi-message report.

# What you need

1. COPY ```monitor.sh``` inside your ```/favorite/dir ```<br>
note1: add +x permission to ```monitor.sh ```
2. CRON and TELEGRAM-SEND

## ```monitor.sh``` syntax:<br>

Please, *respect the order* of the args: <br>
<br>
```<txt>```: a txt file with the GitHub/HTTP links (one link per line);<br>
<br>
```<rundir>```: path to ```/favorite/dir``` where ```monitor.sh``` is stored;<br>
<br>
```<pipeline>```: the name of your pipeline (to send you a meaningful report).<br>
<br>

## CRON and TELEGRAM-SEND installation
Install both [*cron*](https://www.digitalocean.com/community/tutorials/how-to-use-cron-to-automate-tasks-ubuntu-1804) and [*telegram-send*](https://pypi.org/project/telegram-send/) following the installation instructions,

## Create a BOT on Telegram
From the command line run 
  ```
telegram-send --configure
  ```
the steps to follow will be printed on the shell.

## Configure CRON
*cron* needs to know how frequently you want to run ```monitor.sh```.

Change the configuration file running ```crontab -e``` and add, for example:

```
0 0 1 */1 * monitor.sh <txt> <rundir> <pipeline>
```
note2: the script above assumes that ```/favorite/dir``` is in ```$PATH```.<br>
<br>
 ```0 0 1 */1 *``` specifies how frequently you want to monitor the link integrity. <br>
<br>
The searchbar at [CronTab.guru](https://crontab.guru/) allows you to set your favorite schedule up.<br>
<br>
Using this setup, ```monitor.sh``` will silently run in the background on the 1<sup>st</sup> of each month at midnight 🌕.<br>
<br>
note3: do not forget to specify ```SHELL``` and ```PATH``` inside *crontab* and make sure the file ends with a newline.<br>
<br>

 ```
SHELL=/bin/sh
PATH=/all/the/paths/in/your/$PATH

0 0 1 */1 * monitor.sh <listoflinks.txt> <rundir> <pipeline>
 ```

## Example

After,the installation of the dependencies.

I locate  ```soft.txt ``` and  ```monitor.sh ``` in  ```/home/ntellini/LICO ```.

 ```soft.txt``` contains :
  ```
https://github.com/rrwick/Filtlong.git
https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.6-6/GenomeAnalysisTK.jar
http://topaz.genetics.utah.edu/maker_downloads/static/maker-3.00.0-beta.tgz
http://eddylab.org/software/tRNAscan-SE/tRNAscan-SE.tar.gz

  ```
i.e. a GitHub repo, two broken links, and a working link.

My crontab looks like this:
 ```
SHELL=/bin/sh
PATH=/opt/def/anaconda3/bin:/opt/tvs/bin:/home/tools/bin:/home/ntellini/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/lib/mit/sbin:/snap/bin:/home/ntellini/LICO
*/5 * * * * monitor.sh soft.txt /home/ntellini/LICO sppcomp
```
note4: remind to remove the folder with <pipeline> name inside your ```/favorite/dir``` (in my case/home/ntellini/LICO/sppcomp) before the next run starts. 

## The OUTPUT

At the end of the run, the bot sends the report to your Telegram account.

<p align="center" >
<img src="https://github.com/nicolo-tellini/LICO/blob/main/LICO_res.png" width="400" height="800">
<p/>

# RELEASE HISTORY

* v1.0.0 Released on 2023

# DEPENDENCIES

* [cron](https://github.com/samtools/samtools/releases);
* [telegram-send](https://pypi.org/project/telegram-send/).

# TO-DO list
- list link as input
- automatic detection github / not github
- function controller
- no configuration of monitor
